import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/themes/light_theme.dart';
import 'package:login_screen/views/map_screen/map_screen.dart';
import 'package:login_screen/widgets/custom_bottomsheet.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/wating_widgets.dart';
import '../kullanici_park_detay/kullanici_park_detay.dart';
import 'controller/park_screen_controller.dart';

class ParkScreen extends StatefulWidget {
  final String plaka;

  const ParkScreen({Key? key, required this.plaka}) : super(key: key);

  @override
  State<ParkScreen> createState() => _ParkScreenState();
}

class _ParkScreenState extends State<ParkScreen> {
  List<OtoparkModel> otoparklar = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (otoparklar.isEmpty) {
              CustomBottomshett.show(
                context: context,
                child: const Center(child: Text("Bir sorun oluştu. Otopark bulunamadı")),
              );
              return;
            }

            Set<Marker> markers = otoparklar.map((e) {
              String? konum = e.otoparkAdresi;
              double? lat = double.parse(konum!.split(",")[0]);
              double? long = double.parse(konum.split(",")[1]);

              return Marker(

                markerId: MarkerId(e.firebaseId!),
                position: LatLng(lat, long),
                infoWindow: InfoWindow(title: e.otoparkIsmi!),
              );
            }).toSet();

            log("markers uzunluk = ${markers.length}");
            Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(markers: markers)));
          },
          child: const Icon(Icons.location_on),
        ),
        appBar: AppBar(title: const Text("Park Ekranı")),
        body: Consumer(builder: (context, ref, child) {
          final controller = ref.read(parkScreenController);
          return StreamBuilder<QuerySnapshot>(
              stream: controller.tumOtaparklariGetir(),
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
                final response = snapshot.data!.docs;
                List<OtoparkModel> data = snapshot.data!.docs.map((e) {
                  final model = OtoparkModel.fromJson(e.data() as Map<String, dynamic>);
                  model.firebaseId = e.id;
                  return model;
                }).toList();
                otoparklar = data;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        data[index].otoparkIsmi!,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Themes.primaryColor,
                        ),
                      ),
                      onTap: () => controller.otparkDetayaGit(context, data[index], widget.plaka),
                    );
                  },
                  itemCount: data.length,
                );
              });
        }));
  }
}
