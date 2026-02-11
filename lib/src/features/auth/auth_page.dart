import 'package:flutter/foundation.dart';
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
  bool _loading = false;
  String _status = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _signInEmail() async {
    if (_emailController.text.trim().isEmpty || _passController.text.isEmpty) {
      _showError('email y password son requeridos');
      return;
    }
    setState(() {
      _loading = true;
      _status = 'procesando...';
    });
    try {
      await _service.signInWithEmail(
        _emailController.text.trim(),
        _passController.text,
      );
      setState(
        () => _status = 'sesion iniciada ${_service.currentUser?.email}',
      );
    } catch (e) {
      _showError('error signin: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signUpEmail() async {
    if (_emailController.text.trim().isEmpty || _passController.text.isEmpty) {
      _showError('email y password son requeridos');
      return;
    }
    setState(() {
      _loading = true;
      _status = 'procesando...';
    });
    try {
      await _service.signUpWithEmail(
        _emailController.text.trim(),
        _passController.text,
      );
      setState(() => _status = 'usuario creado ${_service.currentUser?.email}');
    } catch (e) {
      _showError('error signup: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signInGoogle() async {
    setState(() {
      _loading = true;
      _status = 'procesando google...';
    });
    try {
      final cred = await _service.signInWithGoogle();
      setState(
        () =>
            _status = cred == null ? 'cancelado' : 'google ${cred.user?.email}',
      );
    } catch (e) {
      _showError('error google: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signOut() async {
    await _service.signOut();
    setState(() => _status = 'sesion cerrada');
  }

  void _showError(String msg) {
    setState(() => _status = msg);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Text(
                        'JLA Gas',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    _loading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _signInEmail,
                                icon: const Icon(Icons.login),
                                label: const Text('Iniciar sesión'),
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                onPressed: _signUpEmail,
                                icon: const Icon(Icons.person_add),
                                label: const Text('Crear cuenta'),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: _signInGoogle,
                                icon: const Icon(Icons.login),
                                label: const Text('Ingresar con Google'),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _signOut,
                                child: const Text('Cerrar sesión'),
                              ),
                            ],
                          ),
                    const SizedBox(height: 8),
                    if (_status.isNotEmpty)
                      Center(
                        child: Text(
                          _status,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
