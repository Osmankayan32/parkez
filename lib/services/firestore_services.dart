import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_screen/models/user_model.dart';
import 'package:login_screen/models/vehicle_model.dart';

class _CollectionPath {
  static const String users = 'users';
  static const String vehicles = 'vehicle';
}

class FireStoreServices {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getVehicles() {
    final vehiceles = _firestore.collection(_CollectionPath.vehicles).snapshots();

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
    final vehicle = _firestore.collection("vehicle").doc("2");
    final vehicleData = await vehicle.get();
    return vehicleData;
  }

  Future<bool> addVehicle({required VehicleModel model}) async {
    final vehicle = _firestore.collection(_CollectionPath.vehicles);
    final vehicleData = await vehicle.add(model.toJson());
    bool isAdded = vehicleData.id.isNotEmpty;
    return isAdded;
  }

  Future<List<UserModel>> userListGet() async {
    final user = _firestore.collection(_CollectionPath.users);
    List<UserModel> userList = await user.get().then((value) {
      final response = value.docs.map((e) => UserModel.fromJson(e.data())).toList();

      return response;
    });
    return userList;
  }
/*
  void userAdd({required UserModel model}) async {
    final user = _firestore.collection(_CollectionPath.users);
    List<UserModel> users= await userListGet();
    int id = users.length + 1;
    model.id = id;
    final userData = await user.add(model.toJson());
  }*/
}
