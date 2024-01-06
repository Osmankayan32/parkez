

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/locator.dart';
import 'package:login_screen/services/auth_service.dart';
import 'package:login_screen/utils/enums.dart';

final  loginController = ChangeNotifierProvider((ref) => LoginScreenController());
class LoginScreenController extends ChangeNotifier{
  ViewState viewState = ViewState.busy;
  late AuthService authServices;
  bool isSignedIn = false;
  LoginScreenController(){
    authServices = getIt<AuthService>();
  }
  init(){
    isSignedIn = authServices.isSignedIn;
    User? user = authServices.getUser();
    if(user != null){
      isSignedIn = true;
    }
    viewState = ViewState.idle;
  }

}