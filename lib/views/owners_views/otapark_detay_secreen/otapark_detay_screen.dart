import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/models/otopark_model.dart';

class OtoparkDetayScreen extends StatelessWidget {
  final OtoparkModel? otoparkModel;

  const OtoparkDetayScreen({super.key, this.otoparkModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(otoparkModel!.otoparkIsmi!)),
      body: Column(
        children: [
          Text(otoparkModel!.otoparkIsmi!),
          Text(otoparkModel!.otoparkAdresi!),
          Text(otoparkModel!.saatlikUcret.toString()),
          Text(otoparkModel!.katSayisi.toString()),
          Text(otoparkModel!.katlar.toString()),
        ],
      )
    );
  }
}
