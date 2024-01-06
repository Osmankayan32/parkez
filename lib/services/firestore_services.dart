import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_screen/models/vehicle_model.dart';
class _CollectionPath {
  static const String users = 'users';
  static const String vehicles = 'vehicle';
}
class FireStoreServices {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getVehicles()  {
    final  vehiceles = _firestore.collection(_CollectionPath.vehicles).snapshots();

    return vehiceles;
  }

  void getVehicleStream() {
    _firestore.collection(_CollectionPath.vehicles).snapshots().listen((event) {
      event.docs.forEach((element) {
        print(element.data());
      });
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getVehicle() async {
    final vehicle =  _firestore.collection("vehicle").doc("2");
    final vehicleData = await vehicle.get();
   return vehicleData;
  }

  Future<bool> addVehicle({required VehicleModel model}) async {
    final vehicle = _firestore.collection(_CollectionPath.vehicles);
    final vehicleData = await vehicle.add(model.toJson());
    bool isAdded = vehicleData.id.isNotEmpty;
    return isAdded;
  }

}