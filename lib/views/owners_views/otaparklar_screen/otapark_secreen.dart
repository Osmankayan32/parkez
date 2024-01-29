import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/widgets/wating_widgets.dart';
import '../../../models/otopark_model.dart';
import '../../../themes/light_theme.dart';
import '../../profile_screen/profile_screen.dart';
import '../otapark_kayit_screen/widgets/step_widget.dart';
import 'controller/otapark_controller.dart';

class OtaparkScreen extends StatefulWidget {
  const OtaparkScreen({Key? key}) : super(key: key);

  @override
  State<OtaparkScreen> createState() => _OtaparkScreenState();
}

class _OtaparkScreenState extends State<OtaparkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Themes.primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(title: const Text("Otapark Ekle")),
                        body: StepWidget(),
                      )),
            );
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Otaparklarım"),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen(otaparSayfasindanMi: true)),
                );
                // Ayarlar butonuna basıldığında yapılacak işlemler
              },
            ),
          ],
        ),
        body: Consumer(builder: (context, ref, child) {
          final controller = ref.read(otoparkController);
          return StreamBuilder<QuerySnapshot>(
              stream: controller.otaparkGetir(),
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
                final response = snapshot.data!.docs;
                List<OtoparkModel> data = snapshot.data!.docs.map((e) {
                  e.id;
                  return OtoparkModel.fromJson(e.data() as Map<String, dynamic>);
                }).toList();
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () => controller.otaparkDetaySayfasinaGit(context, data[index]),
                        title: Text(
                          data[index].otoparkIsmi!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Themes.primaryColor,
                          ),
                        ),
                      );
                    });
              });
        }));
  }
}
