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
        '/admin': (context) => UserManagementPage(),
        '/user': (context) => UserPanel(),
      },
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

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

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  Color _color = Colors.blue;

  late AnimationController _scaleController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _animateBackground();

    // Inicialización del controlador de animaciones
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  void _animateBackground() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        _color = _color == Colors.blue ? Colors.purple : Colors.blue;
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
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
            AnimatedDefaultTextStyle(
              duration: Duration(seconds: 1),
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              child: Text('Bienvenido'),
            ),
            SizedBox(height: 20),
            // Botón con animación de escalado
            ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.2).animate(
                CurvedAnimation(
                  parent: _scaleController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: ElevatedButton(
                child: Text('Iniciar sesión'),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
            SizedBox(height: 20),
            // Botón con animación de rotación
            RotationTransition(
              turns: _rotationController,
              child: ElevatedButton(
                child: Text('Registrarse'),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
