

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login_screen/widgets/custom_buton.dart';
import '../controller/owners_controller.dart';

class KonumSec extends StatefulWidget {
  const KonumSec({super.key});

  @override
  State<KonumSec> createState() => _KonumSecState();
}

class _KonumSecState extends State<KonumSec> {
  GoogleMapController? mapController;

  Set<Marker> markers = Set();

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _addMarker(LatLng location) {
    setState(() {
      markers.clear(); // Önceki işaretçileri temizle
      markers.add(Marker(
        markerId: const MarkerId('selected-location'),
        position: location,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(builder: (context, ref, child) {
      final controller = ref.read(ownerController);
      return SizedBox(
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: markers,
                onTap: (latlng) {
                  log(latlng.toString());

                  _addMarker(latlng);
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.763498865465145, 30.556742312922573), // Başlangıç konumu
                  zoom: 12.0,
                ),
                //markers: null,
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: CustomButon(
                onTap: () {
                  Navigator.pop(context);
                  final stringX = markers.first.position.latitude.toString();
                  final stringY = markers.first.position.longitude.toString();
                  controller.konumAta("$stringX, $stringY");
                },
                child: const Text(
                  "Konumu Kaydet",
                  style: TextStyle(color: Colors.white),
                ),
                width: double.infinity,
              ),
            )
          ],
        ),
      );
    });
  }
}
