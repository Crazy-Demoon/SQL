import 'package:flutter/material.dart';
import 'package:registro/database_helper.dart'; // Asegúrate de importar tu DatabaseHelper

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

  // Lógica de inicio de sesión
  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Verificar el usuario en la base de datos
      Map<String, dynamic>? user = await _dbHelper.getUser(_email, _password);

      if (user != null) {
        // Si el usuario es administrador
        if (user['isAdmin'] == 1) {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/user');
        }
      } else {
        // Si no hay usuario encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Correo o contraseña incorrectos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        backgroundColor: Colors.blueAccent, // Cambiar el color del AppBar
      ),
      body: Stack(
        children: [
          // Fondo colorido y degradado
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.deepPurpleAccent, // Color del cuadro de login
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Campo de correo
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) => _email = value!.trim(),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese un correo' : null,
                        ),
                        SizedBox(height: 20),

                        // Campo de contraseña
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          onSaved: (value) => _password = value!.trim(),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese una contraseña' : null,
                        ),
                        SizedBox(height: 20),

                        // Botón de "Entrar"
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Entrar', style: TextStyle(fontSize: 16)),
                          onPressed: _login,
                        ),
                        SizedBox(height: 20),

                        // Botón para regresar a la página de bienvenida
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Regresar a Bienvenida',
                              style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
