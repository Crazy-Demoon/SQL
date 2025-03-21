import 'package:flutter/material.dart';
import 'package:registro/database_helper.dart'; // Asegúrate de tener la referencia de tu DatabaseHelper

class UserPanel extends StatefulWidget {
  const UserPanel({Key? key}) : super(key: key);

  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Método para cambiar la contraseña
  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Verificar que la contraseña actual sea correcta
      var user = await _dbHelper.getUserByEmail(
          'usuario@myapp.com'); // Reemplaza con el correo del usuario logueado
      if (user != null && user['password'] == _currentPassword) {
        // Actualizar la contraseña
        int result = await _dbHelper.updateUser({
          '_id': user['_id'],
          'email': user['email'],
          'password': _newPassword,
          'isAdmin': user['isAdmin'],
        });

        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contraseña actualizada exitosamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar la contraseña')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña actual incorrecta')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Usuario'),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Contenido centrado
          Center(
            child: Card(
              color: Colors.white.withOpacity(0.85), // Fondo semitransparente
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Bienvenido, Usuario',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Aquí puedes gestionar tu cuenta, ver tus reservas, y mucho más.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Mostrar formulario de cambiar contraseña
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Cambiar contraseña'),
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Campo de contraseña actual
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña actual',
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      obscureText: true,
                                      onSaved: (value) =>
                                          _currentPassword = value!,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Ingrese la contraseña actual';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    // Campo de nueva contraseña
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Nueva contraseña',
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      obscureText: true,
                                      onSaved: (value) => _newPassword = value!,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Ingrese la nueva contraseña';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Cerrar el diálogo
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _changePassword();
                                    Navigator.pop(
                                        context); // Cerrar el diálogo después de cambiar
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Cambiar contraseña',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
