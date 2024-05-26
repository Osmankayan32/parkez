import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/constants.dart';

class GoogleMapWidget extends StatefulWidget {

  final Set<Marker> markers;
  const GoogleMapWidget({Key? key,required this.markers}) : super(key: key);

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? _controller;
  LatLng? _currentPosition;


  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      if (_controller != null) {
        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentPosition!,
              zoom: 19,
            ),
          ),
        );
      }
    } else {
      // Handle permission denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition ?? LatLng(37.763498865465145, 30.556742312922573), // Ba
        zoom: 17,
      ),

      onMapCreated: (GoogleMapController controller) async {
        _controller = controller;
        //  yollar beyaz 0lsun
        _controller!.setMapStyle(mapsStyle);

        await _getCurrentLocation();

        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentPosition!,
              zoom: 19,
            ),
          ),
        );
      },
      markers: widget.markers,
      trafficEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  /*
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
   */
}
