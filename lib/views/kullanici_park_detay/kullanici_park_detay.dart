import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/views/owners_views/otapark_detay_secreen/controller/otopark_detay_controller.dart';

import '../../../themes/light_theme.dart';
import '../../widgets/custom_time_picker.dart';
import '../../widgets/wating_widgets.dart';
import 'controller/kullanici_park_controller.dart';
import 'widgets/park_onaylama_widget.dart';

class KullaniciParkDetayScreen extends StatelessWidget {
  final String plaka;
  final OtoparkModel otoparkModel;

  const KullaniciParkDetayScreen({super.key, required this.otoparkModel, required this.plaka});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(otoparkModel!.otoparkIsmi!)),
        body: Consumer(builder: (context, ref, child) {
          final controller = ref.read(kullaniciParkController);
          return StreamBuilder<DocumentSnapshot>(
              stream: controller.otoparkGetir(otoparkModel.firebaseId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const WatingWidget();
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Hata oluştu"));
                }
                if (snapshot.data == null) {
                  return const Center(child: Text("Araç bulunamadı"));
                }
                OtoparkModel data = OtoparkModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                return Column(
                  children: [
                    Consumer(builder: (context, ref, child) {
                      int aktifIndex = ref.watch(kullaniciParkController.select((value) => value.aktifKatIndex));
                      return DropdownButton(
                        value: aktifIndex,
                        onChanged: (index) {
                          controller.aktifKatIndexAta(index as int);
                        },
                        items: [
                          ...List.generate(otoparkModel.katlar!.length, (index) {
                            return DropdownMenuItem(
                              value: index,
                              child: Text(otoparkModel.katlar![index].katIsmi!),
                            );
                          })
                        ],
                      );
                    }),
                    Expanded(
                      child: Consumer(builder: (context, ref, child) {
                        final controller = ref.watch(kullaniciParkController);
                        final int aktifIndex = ref.watch(kullaniciParkController.select((value) => value.aktifKatIndex));
                        final katmodel = otoparkModel.katlar![aktifIndex];

                        return PageView.builder(
                            itemCount: katmodel.siraSayisi,
                            onPageChanged: (index) {
                              //controller.aktifIndexiDegistir(index);
                            },
                            itemBuilder: (context, siraIndex) {
                              final aracKapasitesi = katmodel.katKapasitesi! / katmodel.siraSayisi!;
                              final parkYerleri =
                                  katmodel.parkYerleri!.skip(siraIndex * aracKapasitesi.toInt()).take(aracKapasitesi.toInt()).toList();
                              return GridView.count(
                                crossAxisCount: 2,
                                children: [
                                  ...List.generate(aracKapasitesi.toInt(), (index) {
                                    return parkYeriWidger(
                                      parkYerleri[index],
                                      controller: controller,
                                      plaka: plaka,
                                      tersCevir: index % 2 == 0,
                                      otoparkModel: otoparkModel,
                                      parkIndex: index,
                                      katIndex: aktifIndex,
                                      /*
                                      parkYerleri[index],
                                      context: context,
                                      model: otoparkModel,
                                      parkIndex: index,
                                      katIndex: aktifIndex,
                                      tersCevir: index % 2 == 0,
                                      */
                                    );
                                  })
                                ],
                              );
                              /*
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: (kat.katKapasitesi ?? 0) ~/ 2,
                                      controller: ScrollController(keepScrollOffset: false),
                                      itemBuilder: (context, parkIndex) {
                                        int firstIndex = parkIndex * 2;
                                        ParkYeriModel? parkYeri1 = kat.parkYerleri?[firstIndex];
                                        parkYeri1 ??= ParkYeriModel(parkYeriIsmi: "${firstIndex + 1}", aracVarMi: false);

                                        int secondIndex = parkIndex * 2 + 1;
                                        ParkYeriModel? parkYeri2 = kat.parkYerleri?[secondIndex];
                                        parkYeri2 ??= ParkYeriModel(parkYeriIsmi: "${secondIndex + 1}", aracVarMi: false);

                                        return Row(
                                          children: [
                                            Expanded(
                                                child: parkYeriWidger(
                                              parkYeri1,
                                              tersCevir: true,
                                              context: context,
                                              model: otoparkModel,
                                              parkIndex: firstIndex,
                                              katIndex: katIndex,
                                            )),
                                            Container(height: 50, width: 1, color: Colors.black),
                                            Expanded(
                                                child: parkYeriWidger(
                                              parkYeri2,
                                              context: context,
                                              model: otoparkModel,
                                              parkIndex: secondIndex,
                                              katIndex: katIndex,
                                            )),
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Divider(
                                            height: 15,
                                            thickness: 1,
                                            color: Colors.black,
                                          ),
                                        );
                                      })
                                ],
                              ),
                            );
                            */
                            });
                      }),
                    ),
                    /*
                    izedBox(
                      height: 40,
                      child: Consumer(builder: (context, ref, child) {
                        final int aktifIndex = ref.watch(kullaniciParkController.select((value) => value.aktifKatIndex));
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(data.katlar!.length, (index) {
                              bool aktifMi = aktifIndex == index;

                              return AnimatedContainer(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                duration: Duration(milliseconds: 500),
                                height: 15,
                                width: aktifMi ? 40 : 15,
                                decoration: BoxDecoration(
                                  color: Themes.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            })
                          ],
                        );
                      }),
                    )
                     */
                  ],
                );
              });
        }));
  }

  Widget parkYeriWidger(
    ParkYeriModel parkYeri, {
    bool tersCevir = false,
    required OtoparkModel otoparkModel,
    required KullaniciParkController controller,
    required int katIndex,
    required int parkIndex,
    required String plaka,
  }) {
    return Builder(builder: (context) {
      if (parkYeri.bitisTarihi != null && parkYeri.bitisTarihi!.isNotEmpty) {
        DateTime bistiZamani = DateTime.parse(parkYeri.bitisTarihi!);
        if (bistiZamani.isBefore(DateTime.now())) {
          parkYeri.aracVarMi = false;
        }
      }
      bool isMe = parkYeri.aracPlaka == plaka;
      Color color = parkYeri.aracVarMi! ? Themes.primaryColor : Colors.black38;
      if (isMe && parkYeri.aracVarMi!) {
        color = Colors.green;
      }
      return InkWell(
        onTap: () {
          if (parkYeri.aracVarMi!) {
            if (isMe) {
              showDialog(
                  context: context,
                  builder: (context) => DateAlertWidget(
                        bitis: parkYeri.bitisTarihi!,
                        baslangic: parkYeri.baslangicTarihi!,
                        model: otoparkModel,
                        plaka: plaka,
                        katIndex: katIndex,
                        parkIndex: parkIndex,
                      ));
              return;
            }
            return;
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ParkOnaylama(
                        otoparkModel: otoparkModel,
                        katIndex: katIndex,
                        parkIndex: parkIndex,
                        plaka: plaka,
                      )));

          //controller.otoparkAlaniSec(model: otoparkModel, katIndex: katIndex, parkIndex: parkIndex, plaka: plaka);
        },
        child: Column(
          children: [
            Text(
              parkYeri.parkYeriIsmi!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Themes.primaryColor,
              ),
            ),
            Transform.rotate(
              angle: tersCevir ? 180 * 3.14 / 180 : 0,
              child: Container(
                height: 50,
                width: 200,
                margin: const EdgeInsets.all(10),
                //color: parkYeri.aracVarMi! ? Colors.green : Colors.red,
                child: SvgPicture.asset(
                  parkYeri.aracVarMi! ? "assets/icons/select_car.svg" : "assets/icons/un_select_car.svg",
                  color: color, //parkYeri.aracVarMi! ? Colors.green : Colors.red,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class DateAlertWidget extends StatefulWidget {
  final OtoparkModel model;
  final String plaka;
  final int katIndex;
  final int parkIndex;

  const DateAlertWidget({
    super.key,
    required this.bitis,
    required this.baslangic,
    required this.model,
    required this.plaka,
    required this.katIndex,
    required this.parkIndex,
  });

  final String bitis;
  final String baslangic;

  @override
  State<DateAlertWidget> createState() => _DateAlertWidgetState();
}

class _DateAlertWidgetState extends State<DateAlertWidget> {
  String bitis = "";
  String baslangic = "";

  bool guncelemeOldumu = false;

  @override
  void initState() {
    bitis = widget.bitis;
    baslangic = widget.baslangic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Park Bilgisi"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () {
                DateTime date = DateTime.now();
                ExCupertinoDatePicker.showPicker(
                  context,
                  mode: CupertinoDatePickerMode.time,
                  minimumDate: DateTime.now(),
                  onDateTimeChanged: (dateTime) {
                    date = dateTime;
                  },
                  selectFunction: () {
                    setState(() {
                      log("tarih seçildi : $date");
                      baslangic = DateFormat("yyyy-MM-dd HH:mm").format(date);
                      guncelemeOldumu = true;
                    });
                    Navigator.pop(context);
                  },
                );
              },
              child: Text(
                "Başlangıç Tarihi : ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(baslangic))}",
                style: const TextStyle(color: Colors.black),
              )),
          TextButton(
            onPressed: () {
              DateTime date = DateTime.now();
              DateTime minimumDate = DateTime.parse(widget.baslangic);
              minimumDate = minimumDate.add(const Duration(minutes: 15));
              ExCupertinoDatePicker.showPicker(
                context,
                mode: CupertinoDatePickerMode.dateAndTime,
                minimumDate: minimumDate,
                initialDate: DateTime.parse(widget.bitis),
                onDateTimeChanged: (dateTime) {
                  date = dateTime;
                },
                selectFunction: () {
                  setState(() {
                    log("tarih seçildi : $date");
                    bitis = DateFormat("yyyy-MM-dd HH:mm").format(date);
                    guncelemeOldumu = true;
                  });
                  Navigator.pop(context);
                },
              );
            },
            child: Text(
              "Bitiş Tarihi : ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(baslangic))}",
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("İptal", style: TextStyle(color: Colors.red))),
              if (guncelemeOldumu)
                Consumer(builder: (context, ref, child) {
                  final controller = ref.read(kullaniciParkController);
                  return TextButton(
                      onPressed: () {
                        controller.otoparkiGuncele(
                          model: widget.model,
                          plaka: widget.plaka,
                          katIndex: widget.katIndex,
                          parkIndex: widget.parkIndex,
                          baslangic: baslangic,
                          bitis: bitis,
                        );
                        Navigator.pop(context, {"baslangic": baslangic, "bitis": bitis, "guncelleme": guncelemeOldumu});
                      },
                      child: const Text("Güncelle"));
                })
            ],
          )
        ],
      ),
    );
  }
}
