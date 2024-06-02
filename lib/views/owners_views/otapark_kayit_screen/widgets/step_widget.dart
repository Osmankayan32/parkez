import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/otopark_model.dart';
import 'package:login_screen/widgets/custom_buton.dart';
import 'package:login_screen/widgets/custom_textField.dart';
import '../controller/owners_controller.dart';
import 'konum_sec.dart';

class StepWidget extends StatefulWidget {
  @override
  State<StepWidget> createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  int _index = 0;
  int maxIndex = 5;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(builder: (context, ref, child) {
      final controller = ref.read(ownerController);
      return  Stepper(
        currentStep: _index,
        onStepTapped: stepTapped,
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, ControlsDetails details) {
          if (details.stepIndex == 5) {
            return SizedBox(
              width: double.infinity,
              child: CustomButon(
                onTap: () {
                  controller.otaparkiKaydet(context);
                },
                width: 100,
                height: 40,
                child: const Text("Kaydet", style: TextStyle(color: Colors.white)),
              ),
            );
          }
          return Row(
            children: [
              CustomButon(
                onTap: () {
                  if (_index <= 4) {
                    setState(() {
                      _index += 1;
                    });
                  }
                },
                width: 100,
                height: 40,
                child: const Text("Devam Et", style: TextStyle(color: Colors.white)),
              ),
              CustomButon(
                onTap: () {
                  if (_index > 0) {
                    setState(() {
                      _index -= 1;
                    });
                  }
                },
                width: 100,
                height: 40,
                child: const Text("Vazgeç", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
        steps: <Step>[
          Step(
            title: const Text("Otapar İsmi"),
            content: CustomTextField(
              hintText: "Otapark İsmi",
              controller: controller.otaparkIsmiController,
            ),
          ),
          Step(
            title: const Text('Otapar Adresi Seç'),
            content: Consumer(builder: (context, ref, child) {
              String? konum = ref.watch(ownerController.select((value) => value.konum));
              if (konum != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Konum Seçildi",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(konum),
                    const SizedBox(height: 10),
                    TextButton(
                        onPressed: () {
                          showDialog(context: context, builder: (context) => const KonumSec());
                        },
                        child: const Text("Konumu Değiştir"))
                  ],
                );
              }
              return CustomButon(
                height: 40,
                width: 200,
                child: const Text("Konum Seç", style: TextStyle(color: Colors.white)),
                onTap: () {
                  showDialog(context: context, builder: (context) => const KonumSec());
                },
              );
            }),
          ),
          Step(
            title: const Text("Otapar Kat Sayısı"),
            content: CustomTextField(hintText: "Kat Sayısı", controller: controller.katSayisiController),
          ),
          Step(
            title: const Text("Kat Bilgileri"),
            content: Consumer(builder: (context, ref, child) {
              String? katSayisiString = ref.watch(ownerController.select((value) => value.katSayisiController.text)) ?? "0";
              if (katSayisiString.isEmpty) return const Text("Kat Sayısı boş olama");
              final katSayisi = int.parse(katSayisiString);

              if (katSayisi == 0) return const Text("Kat Sayısı 0 Olamaz, Lütfen Tekrar Deneyiniz");

              if (katSayisi < 0) return const Text("Kat Sayısı 1'den küçük olamaz");

              return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: katSayisi,
                  itemBuilder: (context, index) {
                    return _KatKayitWidget();
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(color: Colors.black);
                  });
            }),
          ),
          Step(
              title: const Text("Saatlik Ücret"),
              content: CustomTextField(
                hintText: "Saatlik Ücret",
                controller: controller.saatlikUcretController,
              )),
          const Step(
            state: StepState.complete,
            title: Text("Kaydet"),
            content: SizedBox.shrink(),
          )
        ],
      );
    });
  }

  void stepTapped(int index) {
    setState(() {
      _index = index;
    });
  }
}

class _KatKayitWidget extends StatefulWidget {
  @override
  State<_KatKayitWidget> createState() => _KatKayitWidgetState();
}

class _KatKayitWidgetState extends State<_KatKayitWidget> {
  bool kayitEdildiMi = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(kayitEdildiMi){
      return const Icon(Icons.check_circle, color: Colors.green, size: 50,);
    }
    final isimController = TextEditingController();
    final kapasiteController = TextEditingController();
    final siraController = TextEditingController();
    return Consumer(builder: (context, ref, child) {
      final controller = ref.read(ownerController);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(hintText: "Kat İsmi", controller: isimController),
          CustomTextField(hintText: "Araç Kapasitesi", controller: kapasiteController),
          CustomTextField(hintText: "Katta bulunan sıra sayısı", controller: siraController),
          CustomButon(
            onTap: () {
              final isim = isimController.text;
              final kapasite = int.parse(kapasiteController.text);
              final sira = int.parse(siraController.text);
              final katModel = OtaparkKatModel(
                katIsmi: isim,
                katKapasitesi: kapasite,
                siraSayisi: sira,
              );
              controller.katlar.add(katModel);
              setState(() {
                kayitEdildiMi = true;
              });
            },
            width: 100,
            height: 40,
            child: const  Text(
              "Kaydet",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    });
  }
}
