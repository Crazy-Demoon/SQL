import 'package:flutter/material.dart';

class HotelHomeScreen extends StatelessWidget {
  final String hotelName;

  HotelHomeScreen({required this.hotelName, required name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenido al $hotelName")),
      body: Center(child: Text("Hola, ¡Bienvenido al hotel $hotelName!")),
    );
  }
}
