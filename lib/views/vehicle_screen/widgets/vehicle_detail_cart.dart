import 'package:flutter/material.dart';

class VehicleDetailCart extends StatelessWidget {
  final String name;
  final String plaka;

  const VehicleDetailCart({Key? key, required this.name, required this.plaka}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.car_rental_rounded)),
      title: Text(name),
      subtitle: Text(plaka),
    );
  }
}
