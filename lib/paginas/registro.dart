import 'package:flutter/material.dart';
import 'package:registro/db/database_helper.dart';

class HotelRegisterScreen extends StatefulWidget {
  @override
  _HotelRegisterScreenState createState() => _HotelRegisterScreenState();
}

class _HotelRegisterScreenState extends State<HotelRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  bool _isLoading = false;

  final RegExp _emailRegExp = RegExp(
    r'^[^@]+@[^@]+\.[^@]+',
  );

  Future<void> _registerHotel() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String hotelName = _hotelNameController.text.trim();
      String ownerEmail = _emailController.text.trim();
      String contactNumber = _contactNumberController.text;

      bool exists = await HotelDatabaseHelper.instance.hotelExists(ownerEmail);

      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El correo ya está registrado')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      int hotelId = await HotelDatabaseHelper.instance
          .insertHotel(hotelName, ownerEmail, contactNumber);

      setState(() {
        _isLoading = false;
      });

      if (hotelId > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hotel registrado con éxito')),
        );
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar el hotel')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://media.giphy.com/media/xT9IgzoKnwFNmISR8I/giphy.gif',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(
                0.5), // Oscurece un poco el fondo para mejor visibilidad
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 17, 17, 17).withOpacity(
                        0.8), // Fondo semitransparente para el formulario
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _hotelNameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del Hotel',
                          prefixIcon: Icon(Icons.business),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre del hotel es obligatorio';
                          } else if (value.trim().length < 3) {
                            return 'El nombre del hotel debe tener al menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
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
                        controller: _contactNumberController,
                        decoration: InputDecoration(
                          labelText: 'Número de Contacto',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: false,
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
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _registerHotel,
                              child: Text('Registrar Hotel'),
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
