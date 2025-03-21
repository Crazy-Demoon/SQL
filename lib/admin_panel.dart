import 'package:flutter/material.dart';
import 'package:registro/database_helper.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    List<Map<String, dynamic>> users = await _dbHelper.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  void _deleteUser(int id) async {
    int result = await _dbHelper.deleteUser(id);
    if (result > 0) {
      _loadUsers(); // Recargar la lista de usuarios
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Usuario eliminado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 5,
            child: ListTile(
              title: Text(user['email']),
              subtitle:
                  Text(user['isAdmin'] == 1 ? 'Administrador' : 'Usuario'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteUser(user['_id']),
              ),
              onTap: () {
                // Aquí puedes agregar funcionalidad para editar o ver detalles
              },
            ),
          );
        },
      ),
    );
  }
}
