import 'package:flutter/material.dart';
import 'package:login_screen/views/profile_screen/profile_screen.dart';

import 'widgets/step_widget.dart';

class OwnersScreen extends StatelessWidget {
  const OwnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
  }
}
