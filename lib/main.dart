import 'package:flutter/material.dart';
import 'package:registro/admin_panel.dart';
import 'package:registro/login_page.dart';
import 'package:registro/register_page.dart';
import 'package:registro/user_panel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/admin': (context) => AdminPanel(),
        '/user': (context) => UserPanel(),
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  // Aquí agregamos una animación de fondo simple con AnimatedContainer.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  Color _color = Colors.blue;

  @override
  void initState() {
    super.initState();
    _animateBackground();
  }

  void _animateBackground() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        // Alterna entre dos colores de fondo, podrías mejorar la animación o agregar imágenes.
        _color = _color == Colors.blue ? Colors.purple : Colors.blue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      color: _color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Iniciar sesión'),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ElevatedButton(
              child: Text('Registrarse'),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
          ],
        ),
      ),
    );
  }
}
