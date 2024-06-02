
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_screen/models/vehicle_model.dart';
import 'package:login_screen/themes/light_theme.dart';

class RandevuCart extends StatelessWidget {
  const RandevuCart({
    super.key,
    required this.vehicle,
  });

  final VehicleModel vehicle;

  @override
  Widget build(BuildContext context) {
    DateTime parkBitisZamani = DateTime.parse(vehicle.aracParkBitisZamani!);
    String formattedDate = DateFormat('dd-MM-yyyy – kk:mm').format(parkBitisZamani);
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Themes.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      height: 120,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 90,
            width: 90,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Themes.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Image.asset('assets/images/car.png')),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Araç Adı: ${vehicle.aracName}"),
                Text("Plaka: ${vehicle.plaka}"),
                Text('Bitiş Tarihi: $formattedDate'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
