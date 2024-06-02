import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../services/firestore_services.dart';
import '../../services/locator.dart';

class MeetingController extends ChangeNotifier{
  late final FireStoreServices _fireStoreServices;

  MeetingController(){
    _fireStoreServices = getIt<FireStoreServices>();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getVehicles() {
    return _fireStoreServices.getVehicles();
  }

}