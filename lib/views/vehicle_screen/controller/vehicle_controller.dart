import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/vehicle_model.dart';
import 'package:login_screen/services/firestore_services.dart';
import 'package:login_screen/services/locator.dart';
import 'package:login_screen/utils/constants.dart';

final vehicleController = ChangeNotifierProvider((ref) => VehicleController());

class VehicleController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController plakaController = TextEditingController();
  final PageController pageController = PageController(initialPage: 0);
   int vehicleType = 0;
  late FireStoreServices _fireStoreServices;


  VehicleController() {
    _fireStoreServices = getIt<FireStoreServices>();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getVehicles() {
    return _fireStoreServices.getVehicles();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getData() {
    return _fireStoreServices.getVehicle();
  }
  void aktifIndexiAta(int index){
    vehicleType = index;
    notifyListeners();
  }

  Future<bool> addVehicle() async {
    final vehicleModel = VehicleModel(
        aracName: nameController.text,
        plaka: plakaController.text,
        aracType: vehicleTypes[vehicleType]
    );

    bool isAdd = await _fireStoreServices.addVehicle(model: vehicleModel);
    return isAdd;
  }
}
