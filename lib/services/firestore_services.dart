import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/models/user_model.dart';
import 'package:login_screen/models/vehicle_model.dart';

class _CollectionPath {
  static const String users = 'users';
  static const String vehicles = 'vehicle';
  static const String otopark = 'otopark';
}

class FireStoreServices {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getVehicles() {
    User? user = _auth.currentUser;
    if (user == null) {
      return Stream.empty();
    }
    final vehiceles = _firestore
        .collection(_CollectionPath.vehicles)
        .where(
          "uid",
          isEqualTo: user.uid,
        )
        .snapshots();

    return vehiceles;
  }

  void getVehicleStream() {
    _firestore.collection(_CollectionPath.vehicles).snapshots().listen((event) {
      event.docs.forEach((element) {
        print(element.data());
      });
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getVehicle() async {
    User user = _auth.currentUser!;

    final vehicle = _firestore.collection("vehicle").where("uid", isEqualTo: user.uid);
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

  void otaparkEkle(OtoparkModel model) {
    final otopark = _firestore.collection(_CollectionPath.otopark);
    otopark.add(model.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> kullaniciyaAitOtaparkGetir() {
    final otopark = _firestore.collection(_CollectionPath.otopark).where("uid", isEqualTo: _auth.currentUser!.uid);

    return otopark.snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> futureGetOtopark() async {
    final otopark = _firestore.collection(_CollectionPath.otopark).where("uid", isEqualTo: _auth.currentUser!.uid);
    final otoparkData = await otopark.get();

    return otoparkData;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> tumOtoparklariGetir() {
    final otopark = _firestore.collection(_CollectionPath.otopark);

    return otopark.snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> idGoreOtaparkGetir(String id) {
    final otopark = _firestore.collection(_CollectionPath.otopark).doc(id);
    return otopark.snapshots();
  }

  void otaparkAlaniSec({required OtoparkModel model, required int katIndex, required int parkAlaniIndex,required String plaka}) {
    final otopark = _firestore.collection(_CollectionPath.otopark).doc(model.firebaseId);
     model.katlar![katIndex].parkYerleri![parkAlaniIndex].aracPlaka = plaka;
    model.katlar![katIndex].parkYerleri![parkAlaniIndex].aracVarMi = true;
    otopark.update(model.toMap());
  }

  void vehicleUpdate(VehicleModel vehicleModel){
    final vehicle = _firestore.collection(_CollectionPath.vehicles).doc(vehicleModel.id);
    vehicle.update(vehicleModel.toJson());
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
