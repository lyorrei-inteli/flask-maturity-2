import 'package:flutter/material.dart';
import 'package:flutter_application/services/users_api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      await UsersApiService().login(username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Login bem-sucedido. Redirecionando para a lista de tarefas.')),
      );
      Navigator.pushReplacementNamed(context, '/list-tasks');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login falhou. Por favor, tente novamente.')),
      );
    }
  }

  void _createAccount(context) {
    Navigator.pushNamed(context, '/create-account');
  }

  void _captureImage(context) {
    Navigator.pushNamed(context, '/capture-image');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _createAccount(context),
              child: const Text('Criar conta'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _captureImage(context),
              child: const Text('Capturar Imagem'),
            ),
          ],
        ),
      ),
    );
  }
}
