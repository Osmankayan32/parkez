import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/views/owners_views/otaparklar_screen/otapark_secreen.dart';
import 'package:login_screen/views/profile_screen/profile_screen.dart';
import 'package:login_screen/widgets/wating_widgets.dart';

import 'controller/owners_controller.dart';
import 'widgets/step_widget.dart';

class OwnersScreen extends StatelessWidget {
  const OwnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final controller = ref.read(ownerController);
        return FutureBuilder(
            future: controller.kayitliOtaparkVarMi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const WatingWidget();
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Hata oluştu"));
              }
              if (snapshot.data == true) {
                return const OtaparkScreen();
              }

              return Scaffold(
                  appBar: AppBar(
                    title: const Text("Otapar Sahibi"),
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
                  body: SingleChildScrollView(
                    child: StepWidget(),
                  ));
            });
      }),
    );
  }
}
