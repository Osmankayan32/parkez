import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/vehicle_model.dart';
import 'package:login_screen/services/firestore_services.dart';
import 'package:login_screen/services/locator.dart';
import 'package:login_screen/views/profile_screen/profile_screen.dart';
import 'package:login_screen/views/vehicle_screen/controller/vehicle_controller.dart';
import 'package:login_screen/views/vehicle_screen/vehicle_screen.dart';
import 'package:login_screen/widgets/custom_buton.dart';

import '../park_screen/park_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoşgeldiniz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              // Ayarlar butonuna basıldığında yapılacak işlemler
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Consumer(builder: (context, ref, child) {
                VehicleModel? vehicle = ref.watch(vehicleController.select((value) => value.seciliArac));

                return vehicle == null
                    ? const SizedBox.shrink()
                    : Text(
                        "${vehicle.aracName} - ${vehicle.plaka}" ?? "plaka null geldi",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      );
              }),
              Image.asset("assets/images/City driver-pana.png"),
              Consumer(builder: (context, ref, child) {
                final controller = ref.read(vehicleController);
                return CustomButon(
                  onTap: () async {
                    final response = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VehicleSecreen()),
                    );
                    if (response == null) return;
                    final vehicleModel = VehicleModel.fromJson(response);
                    controller.selectVehicle(vehicleModel);
                  },
                  width: 200,
                  child: const Text("Araç Seç", style: TextStyle(fontSize: 18, color: Colors.white)),
                );
              }),
              Consumer(builder: (context, ref, child) {
                VehicleModel? vehicle = ref.watch(vehicleController.select((value) => value.seciliArac));
                return CustomButon(
                  onTap: vehicle==null?null:() {

                    String plaka = vehicle.plaka!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ParkScreen(plaka: plaka)),
                    );
                  },
                  child: Text("Otaparklar", style: TextStyle(fontSize: 18, color: Colors.white)),
                  width: 200,
                );
              }),
              CustomButon(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VehicleSecreen()),
                  );

                  // "Araç Seç" butonuna basıldığında yapılacak işlemler
                },
                width: 200,
                child: const Text("Randevularım", style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
