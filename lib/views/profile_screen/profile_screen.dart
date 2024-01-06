import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/views/profile_screen/controller/profile_controler.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final controller = ref.read(profileController);

        return Column(
          children: [
            TextButton(
                onPressed: () {
                  controller.signOut(context);
                },
                child: const Text(
                  'Çıkış Yap',
                  style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                ))
          ],
        );
      }),
    );
  }
}
