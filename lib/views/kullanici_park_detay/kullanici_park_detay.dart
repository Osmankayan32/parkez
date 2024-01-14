import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/views/owners_views/otapark_detay_secreen/controller/otopark_detay_controller.dart';

import '../../../themes/light_theme.dart';
import '../../widgets/wating_widgets.dart';
import 'controller/kullanici_park_controller.dart';

class KullaniciParkDetayScreen extends StatelessWidget {
  final OtoparkModel otoparkModel;

  const KullaniciParkDetayScreen({super.key, required this.otoparkModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(otoparkModel!.otoparkIsmi!)),
        body: Consumer(
          builder: (context, ref, child) {
            final controller = ref.watch(kullaniciParkController);
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
                  OtoparkModel data = OtoparkModel.fromJson( snapshot.data!.data() as Map<String, dynamic>);
                  return Column(
                    children: [
                      Expanded(
                        child: Consumer(builder: (context, ref, child) {
                          final controller = ref.watch(otoparkDetayController);
                          return PageView.builder(
                              itemCount: data.katlar!.length,
                              onPageChanged: (index) {
                                controller.aktifIndexiDegistir(index);
                              },
                              itemBuilder: (context, index) {
                                OtaparkKatModel kat = data.katlar![index];
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        kat.katIsmi!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Themes.primaryColor,
                                        ),
                                      ),
                                      ListView.separated(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: (kat.katKapasitesi ?? 0) ~/ 2,
                                          controller: ScrollController(keepScrollOffset: false),
                                          itemBuilder: (context, index) {
                                            int firstIndex = index * 2;
                                            ParkYeriModel? parkYeri1 = kat.parkYerleri?[firstIndex];
                                            parkYeri1 ??= ParkYeriModel(parkYeriIsmi: "${firstIndex + 1}", aracVarMi: false);

                                            int secondIndex = index * 2 + 1;
                                            ParkYeriModel? parkYeri2 = kat.parkYerleri?[secondIndex];
                                            parkYeri2 ??= ParkYeriModel(parkYeriIsmi: "${secondIndex + 1}", aracVarMi: false);

                                            return Row(
                                              children: [
                                                Expanded(child: parkYeriWidger(parkYeri1, tersCevir: true)),
                                                Container(
                                                  height: 50,
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                                Expanded(child: parkYeriWidger(parkYeri2)),
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
                              });
                        }),
                      ),
                      SizedBox(
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
                    ],
                  );
                });
          }
        ));
  }

  Widget parkYeriWidger(ParkYeriModel parkYeri, {bool tersCevir = false}) {
    return Column(
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
              color: Colors.black38, //parkYeri.aracVarMi! ? Colors.green : Colors.red,
              parkYeri.aracVarMi! ? "assets/icons/select_car.svg" : "assets/icons/un_select_car.svg",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
