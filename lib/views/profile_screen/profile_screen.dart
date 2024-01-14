import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/views/profile_screen/controller/profile_controler.dart';

class ProfileScreen extends StatelessWidget {
  final bool otaparSayfasindanMi;

  const ProfileScreen({Key? key, this.otaparSayfasindanMi = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final controller = ref.read(profileController);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () => otaparSayfasindanMi ? controller.kullaniciOlarakDevamEt(context) : controller.ownersSayfasinaGit(context),
                child: Text(
                  otaparSayfasindanMi ? "Kullanıcı Olarak Devam Et" : "Otopark Sahibi Olarak Devam",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            TextButton(
                onPressed: () => controller.signOut(context),
                child: const Text('Çıkış Yap', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)))
          ],
        );
      }),
    );
  }
}
