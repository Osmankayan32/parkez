import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/otopark_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/firestore_services.dart';
import '../../../../services/locator.dart';
import '../../otaparklar_screen/otapark_secreen.dart';

final ownerController = ChangeNotifierProvider((_) => OwnerController());

class OwnerController extends ChangeNotifier {
  late final FireStoreServices _fireStoreServices;
  late final AuthService _authService;

  OwnerController() {
    _fireStoreServices = getIt<FireStoreServices>();
    _authService = getIt<AuthService>();
  }

  TextEditingController otaparkIsmiController = TextEditingController();
  TextEditingController otaparkAdresiController = TextEditingController();
  TextEditingController otaparkKapasitesiController = TextEditingController();
  TextEditingController katSayisiController = TextEditingController();
  TextEditingController saatlikUcretController = TextEditingController();

  String? konum;
  List<OtaparkKatModel> katlar = [];

  void konumAta(String konum) {
    this.konum = konum;
    notifyListeners();
  }

  void otaparkiKaydet(BuildContext context) {
    final katSayisi = int.parse(katSayisiController.text);
    final saatlikUcret = double.parse(saatlikUcretController.text);
    final isim = otaparkIsmiController.text;
    User? user = _authService.getUser();
    final uid = user!.uid;
    final model = OtoparkModel(
      uid: uid,
      katSayisi: katSayisi,
      otoparkAdresi: konum,
      otoparkIsmi: isim,
      //otoparkKapasitesi: kapasite,
      saatlikUcret: saatlikUcret,
      katlar: katlar,
    );

    otaparkiDbKaydet(model);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const OtaparkScreen();
    }));
  }

  void otaparkiDbKaydet(OtoparkModel model) {
    _fireStoreServices.otaparkEkle(model);
  }

  Future<bool> kayitliOtaparkVarMi() async {
    final data = await _fireStoreServices.futureGetOtopark();
    if (data.docs.isEmpty) {
      return false;
    }
    return true;
  }
}
