import 'package:flutter/material.dart';
import 'package:registro/database_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Consulta en la base de datos.
      var user = await _dbHelper.getUser(_email, _password);
      if (user != null) {
        // Se asume que el objeto user tiene una propiedad 'isAdmin'.
        if (user['isAdmin'] == 1) {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/user');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                onSaved: (value) => _email = value!.trim(),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un correo' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onSaved: (value) => _password = value!.trim(),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese una contraseña' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Entrar'),
                onPressed: _login,
              )
            ],
          ),
        ),
      ),
    );
  }
}
