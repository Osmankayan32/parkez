import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:latlong2/latlong.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/themes/light_theme.dart';
import 'package:login_screen/views/map_screen/map_screen.dart';
import 'package:login_screen/widgets/custom_bottomsheet.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/wating_widgets.dart';
import 'package:http/http.dart' as http;
import '../kullanici_park_detay/kullanici_park_detay.dart';
import 'controller/park_screen_controller.dart';

class ListModel {
  OtoparkModel otoparkModel;
  String uzaklik;
  int kapasite;
  int doluluk;

  ListModel({required this.otoparkModel, required this.uzaklik, required this.kapasite, required this.doluluk});
}

class ParkScreen extends StatefulWidget {
  final String plaka;

  const ParkScreen({Key? key, required this.plaka}) : super(key: key);

  @override
  State<ParkScreen> createState() => _ParkScreenState();
}

class _ParkScreenState extends State<ParkScreen> {
  List<OtoparkModel> otoparklar = [];

  /*

  Future<List<ListModel>> calculat({required List<OtoparkModel> otoparklar}) async {
    // kullanıcının konumunu al

    LatLng currentPosition;
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition = LatLng(position.latitude, position.longitude);
    } else {
      throw Exception("Konum izni verilmedi");
    }

    // Mesafe hesaplamak için yardımcı fonksiyon
    double calculateDistance(LatLng start, LatLng end) {
      final Distance distance = Distance();
      return distance.as(LengthUnit.Kilometer, start, end);
    }

    // Otoparkların uzaklıklarını hesapla ve ListModel nesneleri oluştur
    List<ListModel> listModels = otoparklar.map((e) {
      String? konum = e.otoparkAdresi;
      double? lat = double.parse(konum!.split(",")[0]);
      double? long = double.parse(konum.split(",")[1]);
      LatLng otoparkPosition = LatLng(lat, long);
      double uzaklik = calculateDistance(currentPosition, otoparkPosition);
      return ListModel(otoparkModel: e, uzaklik: uzaklik.toStringAsFixed(2));
    }).toList();

    // Listeyi yakından uzağa sıralama
    listModels.sort((a, b) => double.parse(a.uzaklik).compareTo(double.parse(b.uzaklik)));

    return listModels;
  }

   */

  Future<String> calculateDrivingDistance(LatLng start, LatLng end) async {
    const String apiKey = 'AIzaSyAl5TtsfNcQL0iLuG_STqqYcW5zgEV19no';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end
        .longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final legs = route['legs'][0];
        final distance = legs['distance']['text'];
        return distance;
      } else {
        return "0";
        throw Exception('No routes found');
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  Future<List<ListModel>> calculat({required List<OtoparkModel> otoparklar}) async {
    // Kullanıcının konumunu al
    LatLng currentPosition;
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition = LatLng(position.latitude, position.longitude);
    } else {
      throw Exception("Konum izni verilmedi");
    }

    // Otoparkların uzaklıklarını hesapla ve ListModel nesneleri oluştur
    List<ListModel> listModels = [];
    for (var otopark in otoparklar) {
      String? konum = otopark.otoparkAdresi;
      double? lat = double.parse(konum!.split(",")[0]);
      double? long = double.parse(konum.split(",")[1]);
      LatLng otoparkPosition = LatLng(lat, long);
      String uzaklik = await calculateDrivingDistance(currentPosition, otoparkPosition);
      int doluluk = 0;
      int kapasite = 0;
      for (OtaparkKatModel kat in otopark.katlar ?? []) {
        doluluk += kat.parkYerleri!.where((element) => element.aracVarMi == true).length;
        kapasite += kat.katKapasitesi??0;
      }
      listModels.add(ListModel(
          otoparkModel: otopark,
          uzaklik: uzaklik,
          doluluk: doluluk,
          kapasite: kapasite

      ));
    }

    // Listeyi yakından uzağa sıralama
    listModels.sort((a, b) => double.parse(a.uzaklik.split(' ')[0]).compareTo(double.parse(b.uzaklik.split(' ')[0])));

    return listModels;
  }

  @override
  Widget build(BuildContext context) {
    log("ParkScreen build");
    return Scaffold(
        floatingActionButton: Consumer(builder: (context, ref, child) {
          final controller = ref.read(parkScreenController);
          return FloatingActionButton(
            onPressed: () {
              if (otoparklar.isEmpty) {
                CustomBottomshett.show(
                  context: context,
                  child: const Center(child: Text("Bir sorun oluştu. Otopark bulunamadı")),
                );
                return;
              }

              Set<map.Marker> markers = otoparklar.map((e) {
                String? konum = e.otoparkAdresi;
                double? lat = double.parse(konum!.split(",")[0]);
                double? long = double.parse(konum.split(",")[1]);

                return map.Marker(
                    markerId: map.MarkerId(e.firebaseId!),
                    position: map.LatLng(lat, long),
                    infoWindow: map.InfoWindow(title: e.otoparkIsmi!),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text("Otopark Bilgileri"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Otopark Adı: ${e.otoparkIsmi}"),
                                    Text("Otopark Saatlik Ücreti: ${e.saatlikUcret}"),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      controller.haritadanDon(context, e, widget.plaka);
                                    },
                                    child: const Text("Seç"),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Kapat"))
                                ],
                              ));
                      // controller.otparkDetayaGit(context, e, widget.plaka);
                    });
              }).toSet();

              log("markers uzunluk = ${markers.length}");
              Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(markers: markers)));
            },
            child: const Icon(Icons.location_on),
          );
        }),
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
                  log("Hata oluştu = ${snapshot.error}");
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
                return FutureBuilder(
                    future: calculat(otoparklar: data),
                    builder: (context, AsyncSnapshot<List<ListModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const WatingWidget();
                      }

                      if (snapshot.hasError) {
                        log("Hata oluştu = ${snapshot.error}");
                        return const Center(child: Text("Hata oluştu"));
                      }

                      List<ListModel> data = snapshot.data!;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              data[index].otoparkModel.otoparkIsmi!,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Themes.primaryColor,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(data[index].kapasite.toString(), style: const TextStyle(fontSize: 12, color: Colors.black)),
                                Text("/", style: const TextStyle(fontSize: 12, color: Colors.black)),
                                Text(data[index].doluluk.toString(), style: const TextStyle(fontSize: 12, color: Colors.black)),
                              ],
                            ),
                            subtitle: Text("Uzaklık: ${data[index].uzaklik}", style: const TextStyle(fontSize: 12, color: Colors.black)),
                            onTap: () => controller.otparkDetayaGit(context, data[index].otoparkModel, widget.plaka),
                          );
                        },
                        itemCount: data.length,
                      );
                    });
              });
        }));
  }
}
