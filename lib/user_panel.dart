import 'package:flutter/material.dart';

class UserPanel extends StatelessWidget {
  const UserPanel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Usuario'),
      ),
      body: Center(
        child: Text(
          'Bienvenido, Usuario',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
