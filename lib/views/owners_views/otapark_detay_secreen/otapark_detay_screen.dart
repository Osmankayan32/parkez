import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/views/owners_views/otapark_detay_secreen/controller/otopark_detay_controller.dart';
import 'package:login_screen/widgets/custom_snacbar_widget.dart';

import '../../../themes/light_theme.dart';
import '../../../widgets/wating_widgets.dart';
import '../../profile_screen/profile_screen.dart';
import '../otaparklar_screen/controller/otapark_controller.dart';

class OtoparkDetayScreen extends StatelessWidget {
  final OtoparkModel otoparkModel;

  const OtoparkDetayScreen({super.key, required this.otoparkModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(otoparkModel!.otoparkIsmi!)),
      body: Consumer(builder: (context, ref, child) {
        final controller = ref.read(otoparkDetayController);
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
              OtoparkModel otoparkModel = OtoparkModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

              otoparkModel.firebaseId = snapshot.data!.id;

              return Column(
                children: [
                  Consumer(builder: (context, ref, child) {
                    int aktifIndex = ref.watch(otoparkDetayController.select((value) => value.aktifKatIndex));
                    return DropdownButton(
                      value: aktifIndex,
                      onChanged: (index) {
                        controller.aktifIndexiDegistir(index as int);
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
                  const SizedBox(height: 20),
                  Expanded(
                    child: Consumer(builder: (context, ref, child) {
                      final controller = ref.watch(otoparkDetayController);
                      final int aktifIndex = ref.watch(otoparkDetayController.select((value) => value.aktifKatIndex));
                      final katmodel = otoparkModel.katlar![aktifIndex];

                      return PageView.builder(
                          itemCount: katmodel.siraSayisi,
                          onPageChanged: (index) {
                            //controller.aktifIndexiDegistir(index);
                          },
                          itemBuilder: (context, siraIndex) {
                            final aracKapasitesi = katmodel.katKapasitesi! / katmodel.siraSayisi!;
                            final parkYerleri = katmodel.parkYerleri!.skip(siraIndex * aracKapasitesi.toInt()).take(aracKapasitesi.toInt()).toList();
                            return GridView.count(
                              crossAxisCount: 2,
                              children: [
                                ...List.generate(aracKapasitesi.toInt(), (index) {
                                  return parkYeriWidger(
                                    parkYerleri[index],
                                    context: context,
                                    model: otoparkModel,
                                    parkIndex: index,
                                    katIndex: aktifIndex,
                                    tersCevir: index % 2 == 0,
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
                  SizedBox(
                    height: 40,
                    child: Consumer(builder: (context, ref, child) {
                      final int aktifIndex = ref.watch(otoparkDetayController.select((value) => value.aktifKatIndex));
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(otoparkModel.katlar!.length, (index) {
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
      }),
    );
  }

  Widget parkYeriWidger(
    ParkYeriModel parkYeri, {
    bool tersCevir = false,
    required OtoparkModel model,
    required BuildContext context,
    required int parkIndex,
    required int katIndex,
  }) {
    bool aracVarMi = parkYeri.aracVarMi ?? false;

    if (parkYeri.bitisTarihi != null && parkYeri.bitisTarihi!.isNotEmpty) {
      DateTime bistiZamani = DateTime.parse(parkYeri.bitisTarihi!);
      if (bistiZamani.isBefore(DateTime.now())) {
        aracVarMi = false;
        parkYeri.aracPlaka = null;
      }
    }
    return GestureDetector(
      onTap: () {
        log("parkYeri.aracVarMi : ${parkYeri.aracVarMi}");
        if (aracVarMi == false) {
          return;
        }
        log("parkYeri.baslangicTarihi : ${parkYeri.baslangicTarihi}");
        DateTime baslangicTarihi = DateTime.parse(parkYeri.baslangicTarihi!);
        DateTime bitisTarihi = DateTime.parse(parkYeri.bitisTarihi!);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(parkYeri.aracPlaka ?? "-"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Başlangıç Tarihi : ${DateFormat("dd/MM/yyyy -  HH:mm").format(baslangicTarihi)}"),
                      Text("Bitiş Tarihi : ${DateFormat("dd/MM/yyyy - HH:mm").format(bitisTarihi)}"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Vazgeç"),
                    ),
                    Consumer(builder: (context, ref, child) {
                      final controller = ref.watch(otoparkDetayController);
                      return TextButton(
                        onPressed: () {
                          controller.aracCikar(
                            model: model,
                            parkIndex: parkIndex,
                            katIndex: katIndex,
                            plaka: parkYeri.aracPlaka ?? "",
                          );
                          ExSnacBar.show("Araç Çıkartıldı", color: Colors.green);
                          Navigator.pop(context);
                        },
                        child: Text("Otaparktan Çıkart"),
                      );
                    }),
                  ],
                ));
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
                color: aracVarMi! ? Themes.primaryColor : Colors.black38, //parkYeri.aracVarMi! ? Colors.green : Colors.red,
                "assets/icons/select_car.svg",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            parkYeri.aracPlaka ?? "-",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Themes.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
