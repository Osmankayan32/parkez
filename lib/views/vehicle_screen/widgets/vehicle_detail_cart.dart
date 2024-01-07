import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/vehicle_model.dart';
import 'package:login_screen/views/vehicle_screen/controller/vehicle_controller.dart';

import '../../../utils/constants.dart';

class VehicleDetailCart extends StatelessWidget {
  final VehicleModel model;

  const VehicleDetailCart({Key? key,required this.model}) : super(key: key);

  Widget aracTuruneGoreIconAta(String? aracType) {

    if(VehicleTypes.otomobil == aracType){
      return const Icon(Icons.car_crash);
    }
    if(VehicleTypes.motosiklet == aracType){
      return const Icon(Icons.motorcycle);
    }
    return const Icon(Icons.motorcycle);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.read(vehicleController);

        final seciliArac = ref.watch(vehicleController.select((value) => value)).seciliArac;
       String aracPlaka = seciliArac?.plaka?? "null";
        return ListTile(
          selected: aracPlaka == model.plaka,
          onTap: () {
            controller.selectVehicle(model);
            Navigator.pop(context,model.toJson());
            // Araç detayına git
          },
          leading:  CircleAvatar(child: aracTuruneGoreIconAta(model.aracType)),
          title: Text(model.aracName?? "null"),
          subtitle: Text(model.plaka??"null"),
        );
      }
    );
  }
}
