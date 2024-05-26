import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login_screen/views/map_screen/widgets/goole_maps_widget.dart';

class MapScreen extends StatelessWidget {
  final Set<Marker> markers;
   const MapScreen({Key? key,required this.markers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Harita Ekranı"),
      ),
      body: GoogleMapWidget(markers: markers,),
    );
  }
}

