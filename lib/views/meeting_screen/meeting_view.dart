import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/vehicle_model.dart';
import 'package:login_screen/views/meeting_screen/widgets/randevu_cart.dart';

import '../../themes/light_theme.dart';
import '../../widgets/wating_widgets.dart';
import '../park_screen/park_screen.dart';
import '../vehicle_screen/controller/vehicle_controller.dart';

class MeetingView extends StatefulWidget {
  final VehicleModel vehicleModel;

  MeetingView({super.key, required this.vehicleModel});

  @override
  State<MeetingView> createState() => _MeetingViewState();
}

class _MeetingViewState extends State<MeetingView> {
  List<VehicleModel> vehicleList = [
    //TODO: list
    VehicleModel(
      aracName: 'Tesla Model S',
      plaka: '34 ABC 34',
      aracParkBitisZamani: DateTime.now().add(Duration(hours: 2)).toIso8601String(),
      aracParktaMi: true,
    ),
    VehicleModel(
      aracName: 'Tesla Model S',
      plaka: '34 ABC 34',
      aracParkBitisZamani: DateTime.now().add(Duration(hours: 2)).toIso8601String(),
      aracParktaMi: true,
    ),
    VehicleModel(
      aracName: 'Tesla Model S',
      plaka: '34 ABC 34',
      aracParkBitisZamani: DateTime.now().add(Duration(hours: 2)).toIso8601String(),
      aracParktaMi: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Randevu Detayı'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Themes.primaryColor,
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ParkScreen(plaka: widget.vehicleModel.plaka!)));
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
        /*
      body: ListView.builder(
        itemCount: vehicleList.length,
        itemBuilder: (context, index) {
          return RandevuCart(
            vehicle: vehicleList[index],
          );
        },
      ),
       */
        body: Consumer(builder: (context, ref, child) {
          final controller = ref.read(vehicleController);
          return StreamBuilder<QuerySnapshot>(
              stream: controller.getVehicles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const WatingWidget();
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Hata oluştu"));
                }
                if (snapshot.data == null) {
                  return const Center(child: Text("Araç bulunamadı"));
                }

                List<VehicleModel> data = snapshot.data!.docs.map((e) {
                  final model = VehicleModel.fromJson(e.data() as Map<String, dynamic>);
                  model.id = e.id;
                  return model;
                }).toList();
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      if (data[index].aracParktaMi != true) return SizedBox.shrink();
                      return RandevuCart(
                        vehicle: data[index],
                      );
                    });
              });
        }));
  }
}
