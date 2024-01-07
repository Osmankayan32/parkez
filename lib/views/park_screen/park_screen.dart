import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkScreen extends StatelessWidget {
  const ParkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Park Ekranı")),
      body: Column(
        children: [
          SizedBox(
            height: 400,
            child: _GoogleMap(),

          )
        ],
      ),
    );
  }
}

class _GoogleMap extends StatefulWidget {
  const _GoogleMap({Key? key}) : super(key: key);

  @override
  State<_GoogleMap> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<_GoogleMap> {
  late GoogleMapController mapController ;

  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
          // Örnek olarak iki farklı nokta ekleyelim
          addMarker(LatLng(37.7749, -122.4194), 'Nokta 1');
          addMarker(LatLng(37.773972, -122.431297), 'Nokta 2');
        });
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(37.7749, -122.4194), // Başlangıç konumu
        zoom: 12.0,
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
