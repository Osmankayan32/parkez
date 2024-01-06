import 'package:flutter/material.dart';

// Colors
const kBackgroundColor = Color(0xFFD2FFF4);
const kPrimaryColor = Color(0xFF2D5D70);
const kSecondaryColor = Color(0xFF265DAB);

class VehicleTypes{
  static const int typeSize = 4;
  static const String otomobil = 'Otomobil';
  static const String motosiklet = 'Motosiklet';
  static const String kamyonet = 'Kamyonet';
  static const String minibus = 'Minibüs';
  static const String otobus = 'Otobüs';
}

Map vehicleTypes = {
  0: VehicleTypes.otomobil,
  1: VehicleTypes.motosiklet,
  2: VehicleTypes.kamyonet,
  3: VehicleTypes.minibus,
  4: VehicleTypes.otobus,
};