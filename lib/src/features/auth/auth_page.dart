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
    class _FormState {
      bool loading = false;
    }
      await _service.signInWithEmail(
        _emailController.text.trim(),
        _passController.text,
      );
      final _formState = _FormState();
      setState(
        () => _status = 'sesion iniciada ${_service.currentUser?.email}',
      );
    } catch (e) {
      setState(() => _status = 'error signin: $e');
    }
  }

  Future<void> _signUpEmail() async {
    setState(() => _status = 'procesando...');
        if (_emailController.text.trim().isEmpty || _passController.text.isEmpty) {
          _showError('email y password son requeridos');
          return;
        }
        setState(() {
          _formState.loading = true;
          _status = 'procesando...';
        });
      await _service.signUpWithEmail(
        _emailController.text.trim(),
        _passController.text,
      );
      setState(() => _status = 'usuario creado ${_service.currentUser?.email}');
          setState(() => _status = 'sesion iniciada ${_service.currentUser?.email}');
  }
          _showError('error signin: $e');
  Future<void> _signInGoogle() async {
          setState(() => _formState.loading = false);
        }
    try {
      final cred = await _service.signInWithGoogle();
      setState(
        if (_emailController.text.trim().isEmpty || _passController.text.isEmpty) {
          _showError('email y password son requeridos');
          return;
        }
        setState(() {
          _formState.loading = true;
          _status = 'procesando...';
        });
            _status = cred == null ? 'cancelado' : 'google ${cred.user?.email}',
      );
    } catch (e) {
      setState(() => _status = 'error google: $e');
    }
          setState(() => _status = 'usuario creado ${_service.currentUser?.email}');

          _showError('error signup: $e');
    await _service.signOut();
          setState(() => _formState.loading = false);
        }
  }

  @override
        setState(() {
          _formState.loading = true;
          _status = 'procesando google...';
        });
        try {
          final cred = await _service.signInWithGoogle();
          setState(() => _status = cred == null ? 'cancelado' : 'google ${cred.user?.email}');
        } catch (e) {
          _showError('error google: $e');
        } finally {
          setState(() => _formState.loading = false);
        }
            ),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'password'),
              obscureText: true,
            ),

      void _showError(String msg) {
        setState(() => _status = msg);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
            const SizedBox(height: 12),
            Row(
              children: [
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Center(
                          child: Text('JLA Gas', style: Theme.of(context).textTheme.headlineSmall),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Correo electrónico', prefixIcon: Icon(Icons.email)),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passController,
                          decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock)),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        _formState.loading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(children: [
                                ElevatedButton.icon(onPressed: _signInEmail, icon: const Icon(Icons.login), label: const Text('Iniciar sesión')),
                                const SizedBox(height: 8),
                                OutlinedButton.icon(onPressed: _signUpEmail, icon: const Icon(Icons.person_add), label: const Text('Crear cuenta')),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(onPressed: _signInGoogle, icon: const Icon(Icons.login), label: const Text('Ingresar con Google')),
                                const SizedBox(height: 12),
                                TextButton(onPressed: _signOut, child: const Text('Cerrar sesión')),
                              ]),
                        const SizedBox(height: 8),
                        if (_status.isNotEmpty) Center(child: Text(_status, style: const TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
