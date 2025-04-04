import 'package:flutter/material.dart';
import 'package:registro/database_helper.dart';
import 'package:registro/map.dart'; // Asegúrate de importar el archivo del mapa

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

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var user = await _dbHelper.getUserByEmail('usuario@myapp.com');
      if (user != null && user['password'] == _currentPassword) {
        int result = await _dbHelper.updateUser({
          '_id': user['_id'],
          'email': user['email'],
          'password': _newPassword,
          'isAdmin': user['isAdmin'],
        });

        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Contraseña actualizada exitosamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al actualizar la contraseña')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña actual incorrecta')),
        );
      }
    }
  }

  // Función para navegar al mapa
  void _navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Usuario'),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Card(
              color: Colors.white.withOpacity(0.85),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bienvenido, Usuario',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Aquí puedes gestionar tu cuenta, ver tus reservas, y mucho más.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    // Botón para ir al mapa
                    ElevatedButton(
                      onPressed: _navigateToMap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Ver Mapa',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botón para cambiar contraseña (existente)
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cambiar contraseña'),
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
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
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    decoration: const InputDecoration(
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
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _changePassword();
                                  Navigator.pop(context);
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
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
