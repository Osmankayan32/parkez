import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/services/locator.dart';

import '../../../services/firestore_services.dart';
import '../../owners_views/otapark_detay_secreen/otapark_detay_screen.dart';

final parkScreenController = ChangeNotifierProvider((ref) => ParkScreenController());

class ParkScreenController extends ChangeNotifier {
  late final FireStoreServices _fireStoreServices;

  ParkScreenController() {
    _fireStoreServices = getIt<FireStoreServices>();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> tumOtaparklariGetir() {
    return _fireStoreServices.tumOtoparklariGetir();
  }

  void otparkDetayaGit(BuildContext context, OtoparkModel model) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OtoparkDetayScreen(otoparkModel: model),
    ));
  }
}
