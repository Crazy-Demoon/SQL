import 'package:flutter/material.dart';
import 'package:registro/database_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  // Si quisieras registrar administradores, podrías agregar un campo o lógica adicional.
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Insertar en la base de datos; por defecto, isAdmin = 0 (usuario)
      int id = await _dbHelper.insertUser({
        'email': _email,
        'password': _password,
        'isAdmin': 0, // Cambiar a 1 para admin si se requiere
      });
      if (id > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el registro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
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
                child: Text('Registrar'),
                onPressed: _register,
              )
            ],
          ),
        ),
      ),
    );
  }
}
