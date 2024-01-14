import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final otoparkDetayController = ChangeNotifierProvider((ref) => OtoparkDetayController());

class OtoparkDetayController extends ChangeNotifier {
  int aktifKatIndex = 0;

  void aktifKatIndexAta(int index) {
    aktifKatIndex = index;
    notifyListeners();
  }

  void aktifIndexiDegistir(int index) {
    aktifKatIndex = index;
    notifyListeners();
  }
}
