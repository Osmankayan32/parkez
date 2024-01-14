import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/services/firestore_services.dart';

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

  void aktifIndexiDegistir(int index) {
    aktifKatIndex = index;
    notifyListeners();
  }


  void otoparkAlaniSec({required OtoparkModel model, required int katIndex, required int parkIndex,required String plaka}) {
    _fireStoreServices.otaparkAlaniSec(
      plaka: plaka,
      model: model,
      katIndex: katIndex,
      parkAlaniIndex: parkIndex,
    );
  }
}