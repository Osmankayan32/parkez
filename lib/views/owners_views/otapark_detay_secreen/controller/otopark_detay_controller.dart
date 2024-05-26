import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/otopark_model.dart';

import '../../../../services/firestore_services.dart';
import '../../../../services/locator.dart';

final otoparkDetayController = ChangeNotifierProvider((ref) => OtoparkDetayController());

class OtoparkDetayController extends ChangeNotifier {
  late final FireStoreServices _fireStoreServices;

  OtoparkDetayController() {
    _fireStoreServices = getIt<FireStoreServices>();
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

  void aracCikar({required OtoparkModel model, required int parkIndex, required int katIndex}) {
    _fireStoreServices.araciOtoparktanCikar(
      model: model,
      parkAlaniIndex: parkIndex,
      katIndex: katIndex,
    );
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> otoparkGetir(String otoparkId){
    return _fireStoreServices.idGoreOtaparkGetir(otoparkId);
  }
}
