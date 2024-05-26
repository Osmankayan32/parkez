import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:login_screen/views/kullanici_park_detay/controller/kullanici_park_controller.dart';
import 'package:login_screen/widgets/custom_buton.dart';

import '../../../models/otopark_model.dart';
import '../../../widgets/custom_snacbar_widget.dart';
import '../../../widgets/custom_time_picker.dart';

final TextStyle _style = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
final TextStyle _style2 = TextStyle(fontSize: 18, color: Colors.black54);

class ParkOnaylama extends StatefulWidget {
  const ParkOnaylama({
    Key? key,
    required this.otoparkModel,
    required this.katIndex,
    required this.parkIndex,
    required this.plaka,
  }) : super(key: key);

  final OtoparkModel otoparkModel;
  final int katIndex;
  final int parkIndex;
  final String plaka;

  @override
  State<ParkOnaylama> createState() => _ParkOnaylamaState();
}

class _ParkOnaylamaState extends State<ParkOnaylama> {
  DateTime? baslangicZamani;
  DateTime? bitisZamani;
  String? zamanHatasi;
  double? topUcret = 0;

  String formatDate(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
    return formattedDate;
  }

  String? validateTimes() {
    // bitiş başlangıçtan önce olamaz
    if (baslangicZamani == null || bitisZamani == null) {
      return "Lütfen tarih seçiniz";
    }
    if (bitisZamani!.isBefore(baslangicZamani!)) {
      return "Bitiş zamanı başlangıç zamanından önce olamaz";
    }
    // en az 15 dakika olmalı

    if (bitisZamani!.difference(baslangicZamani!).inMinutes < 15) {
      return "Lütfen en az 15 dakika olacak şekilde seçim yapınız";
    }
    return null;
  }

  void ucretHesapla() {
    double ucret = widget.otoparkModel.saatlikUcret ?? 12;

    int dakika = bitisZamani!.difference(baslangicZamani!).inHours;

    double _topUcret = ucret * dakika;
    setState(() {
      topUcret = _topUcret;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Park Alanı Seç"),
      ),
      body: Consumer(builder: (context, ref, child) {
        final controller = ref.read(kullaniciParkController);
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Başlangıç Zamanı :", style: _style),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            DateTime date = DateTime.now();
                            ExCupertinoDatePicker.showPicker(context, mode: CupertinoDatePickerMode.time, minimumDate: DateTime.now(),
                                onDateTimeChanged: (dateTime) {
                              date = dateTime;
                            }, selectFunction: () {
                              setState(() {
                                baslangicZamani = date;
                              });
                              Navigator.pop(context);
                              log("tarih seçildi : $date");
                            });
                          },
                          child: baslangicZamani == null
                              ? const Text("Seç")
                              : AutoSizeText(
                                  maxLines: 1,
                                  formatDate(baslangicZamani!),
                                  style: _style2,
                                )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Bitiş Zamanı :", style: _style),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            DateTime date = DateTime.now();
                            ExCupertinoDatePicker.showPicker(context, minimumDate: DateTime.now(), onDateTimeChanged: (dateTime) {
                              date = dateTime;
                            }, selectFunction: () {
                              setState(() {
                                bitisZamani = date;
                              });
                              Navigator.pop(context);
                              log("tarih seçildi : $date");
                              ucretHesapla();
                            });
                          },
                          child: bitisZamani == null
                              ? const Text("Seç")
                              : AutoSizeText(
                                  formatDate(bitisZamani!),
                                  style: _style2,
                                )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Toplam Ucret :", style: _style),
                    const SizedBox(width: 10),
                    Text("$topUcret TL", style: _style.copyWith(color: Colors.blue)),
                  ],
                ),
                Spacer(),
                CustomButon(
                    onTap: () {
                      String? validate = validateTimes();
                      if (validate != null) {
                        ExSnacBar.show(validate, color: Colors.red);
                        return;
                      }
                      controller.otoparkAlaniSec(
                        model: widget.otoparkModel,
                        katIndex: widget.katIndex,
                        parkIndex: widget.parkIndex,
                        plaka: widget.plaka,
                      );
                    },
                    height: 50,
                    width: 200,
                    child: const Text("Parkı Onayla", style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        );
      }),
    );
  }
}
