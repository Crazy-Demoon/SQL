import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administrador'),
      ),
      body: Center(
        child: Text(
          'Bienvenido, Administrador',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
