import 'package:flutter/material.dart';
import 'package:registro/db/database_helper.dart';
import 'home_screen.dart';

class HotelLoginScreen extends StatefulWidget {
  @override
  _HotelLoginScreenState createState() => _HotelLoginScreenState();
}

class _HotelLoginScreenState extends State<HotelLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Variable para mostrar el loader

  // Expresión regular básica para validar emails
  final RegExp _emailRegExp = RegExp(
    r'^[^@]+@[^@]+\.[^@]+',
  );

  Future<void> _loginHotelOwner() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mostrar indicador de carga
      });

      String ownerEmail = _emailController.text.trim();
      String contactNumber = _passwordController.text;

      final hotel = await HotelDatabaseHelper.instance.getHotel(ownerEmail);

      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });

      if (hotel != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenido, ${hotel['hotel_name']}')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HotelHomeScreen(name: hotel['hotel_name'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Correo o contraseña incorrectos')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor corrige los errores')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // GIF de fondo desde Internet
          Image.network(
            'https://media.giphy.com/media/xT9IgzoKnwFNmISR8I/giphy.gif', // Cambia esto por otro enlace si deseas
            fit: BoxFit.cover, // Para que cubra toda la pantalla
          ),

          // Capa de oscurecimiento para mejorar la visibilidad
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Formulario de login centrado
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0)
                        .withOpacity(0.8), // Fondo semitransparente
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El correo es obligatorio';
                          } else if (!_emailRegExp.hasMatch(value.trim())) {
                            return 'Introduce un correo válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Número de Contacto',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El número de contacto es obligatorio';
                          } else if (value.length < 6) {
                            return 'El número de contacto debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Mostrar loader mientras carga
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _loginHotelOwner,
                              child: Text('Iniciar Sesión'),
                            ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'),
                        child: Text('¿No tienes cuenta? Regístrate'),
                      ),
                    ],
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
