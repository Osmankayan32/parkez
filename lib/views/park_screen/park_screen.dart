import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/themes/light_theme.dart';

import '../../widgets/wating_widgets.dart';
import '../kullanici_park_detay/kullanici_park_detay.dart';
import 'controller/park_screen_controller.dart';

class ParkScreen extends StatelessWidget {
  final String plaka;

  const ParkScreen({Key? key, required this.plaka}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        data[index].otoparkIsmi!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Themes.primaryColor,
                        ),
                      ),
                      onTap: () => controller.otparkDetayaGit(context, data[index], plaka),
                    );
                  },
                  itemCount: data.length,
                );
              });
        }));
  }
}

class _GoogleMap extends StatefulWidget {
  const _GoogleMap({Key? key}) : super(key: key);

  @override
  State<_GoogleMap> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<_GoogleMap> {
  late GoogleMapController mapController;

  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
          // Örnek olarak iki farklı nokta ekleyelim
          addMarker(const LatLng(37.7749, -122.4194), 'Nokta 1');
          addMarker(const LatLng(37.773972, -122.431297), 'Nokta 2');
        });
      },
      initialCameraPosition: const CameraPosition(
        target: LatLng(37.763498865465145, 30.556742312922573), // Başlangıç konumu
        zoom: 100.0,
      ),
      markers: markers,
    );
  }

  void addMarker(LatLng position, String markerId) {
    Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: markerId),
    );

    setState(() {
      markers.add(marker);
    });
  }
}
