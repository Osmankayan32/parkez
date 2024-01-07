import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/vehicle_model.dart';
final homeController = ChangeNotifierProvider((ref) => HomeController());
class HomeController extends ChangeNotifier{
  VehicleModel? seciliArac;
  void selectVehicle(VehicleModel vehicleModel){
    seciliArac = vehicleModel;
    notifyListeners();
  }
}