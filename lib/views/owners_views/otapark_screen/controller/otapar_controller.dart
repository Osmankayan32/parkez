import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/services/locator.dart';

import '../../../../services/firestore_services.dart';

final otoparkController = ChangeNotifierProvider((ref) => OtoparkController());

class OtoparkController extends ChangeNotifier {
  late final FireStoreServices _fireStoreServices;

  OtoparkController() {
    _fireStoreServices = getIt<FireStoreServices>();
  }


  void otoparkKaydet() {
    print("Otopark kaydedildi");
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> otaparkGetir(){
    return _fireStoreServices.otaparkGetir();
  }
}
