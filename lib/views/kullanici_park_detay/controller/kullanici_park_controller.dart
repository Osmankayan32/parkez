import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/services/firestore_services.dart';

import '../../../models/vehicle_model.dart';
import '../../../services/locator.dart';

final kullaniciParkController = ChangeNotifierProvider((ref) => KullaniciParkController());
class KullaniciParkController extends ChangeNotifier{
  late final FireStoreServices _fireStoreServices;
  KullaniciParkController(){
    _fireStoreServices = getIt<FireStoreServices>();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> otoparkGetir(String otoparkId){
   return _fireStoreServices.idGoreOtaparkGetir(otoparkId);
  }
  int aktifKatIndex = 0;

  void aktifKatIndexAta(int index) {
    aktifKatIndex = index;
    notifyListeners();
  }


  Future<void> otoparkAlaniSec({required OtoparkModel model, required int katIndex, required int parkIndex,required String plaka}) async {

    _fireStoreServices.otaparkAlaniSec(
      plaka: plaka,
      model: model,
      katIndex: katIndex,
      parkAlaniIndex: parkIndex,
    );

    final data =await _fireStoreServices.getVehicle();
    List<VehicleModel> vehicleList = data.docs.map((e) {
      VehicleModel model = VehicleModel.fromJson(e.data());
      model.id = e.id;
      return VehicleModel.fromJson(e.data());
    }).toList();
    VehicleModel vehicleModel = vehicleList.firstWhere((element) => element.plaka == plaka);
    vehicleModel.aracParktaMi = true;

   // _vehicleUpdate(vehicleModel);


  }

  void _vehicleUpdate(VehicleModel vehicleModel){
    _fireStoreServices.vehicleUpdate(vehicleModel);
  }
}