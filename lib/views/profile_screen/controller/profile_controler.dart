import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/locator.dart';
import 'package:login_screen/services/auth_service.dart';
import 'package:login_screen/views/login_screen/login_screen.dart';

final profileController = ChangeNotifierProvider((ref) => ProfileController());

class ProfileController extends ChangeNotifier {
  late AuthService authServices;
  String userName = '';

  ProfileController() {
    authServices = getIt<AuthService>();
  }
  init() {
    userName = authServices.getUser()!.displayName!;
  }
  void signOut(BuildContext context) {
    authServices.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

}