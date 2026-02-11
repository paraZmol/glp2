import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _service = AuthService();
  String _status = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _signInEmail() async {
    setState(() => _status = 'procesando...');
    try {
      await _service.signInWithEmail(
        _emailController.text.trim(),
        _passController.text,
      );
      setState(
        () => _status = 'sesion iniciada ${_service.currentUser?.email}',
      );
    } catch (e) {
      setState(() => _status = 'error signin: $e');
    }
  }

  Future<void> _signUpEmail() async {
    setState(() => _status = 'procesando...');
    try {
      await _service.signUpWithEmail(
        _emailController.text.trim(),
        _passController.text,
      );
      setState(() => _status = 'usuario creado ${_service.currentUser?.email}');
    } catch (e) {
      setState(() => _status = 'error signup: $e');
    }
  }

  Future<void> _signInGoogle() async {
    setState(() => _status = 'procesando google...');
    try {
      final cred = await _service.signInWithGoogle();
      setState(
        () =>
            _status = cred == null ? 'cancelado' : 'google ${cred.user?.email}',
      );
    } catch (e) {
      setState(() => _status = 'error google: $e');
    }
  }

  Future<void> _signOut() async {
    await _service.signOut();
    setState(() => _status = 'sesion cerrada');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('auth mvp')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'email'),
            ),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _signInEmail,
                  child: const Text('sign in'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _signUpEmail,
                  child: const Text('sign up'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _signInGoogle,
              child: const Text('sign in with google'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _signOut, child: const Text('sign out')),
            const SizedBox(height: 12),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
