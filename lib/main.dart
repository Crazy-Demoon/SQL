import 'package:flutter/material.dart';
import 'package:registro/paginas/home_screen.dart';
import 'package:registro/paginas/login.dart';
import 'package:registro/paginas/registro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HotelLoginScreen(),
        '/register': (context) => HotelRegisterScreen(),
        '/home': (context) => HotelHomeScreen(hotelName: 'Hotel Ejemplo'),
      },
    );
  }
}
