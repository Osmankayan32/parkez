
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'car_screen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Ekran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Ayarlar butonuna basıldığında yapılacak işlemler
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CarScreen()),
              ); // "Araç Seç" butonuna basıldığında yapılacak işlemler
              },
              child: const Text('Araç Seç'),
            ),
            ElevatedButton(
              onPressed: () {
                // "Randevularım" butonuna basıldığında yapılacak işlemler
              },
              child: const Text('Randevularım'),
            ),
            ElevatedButton(
              onPressed: () {
                // "..." (diğer seçenekler) butonuna basıldığında yapılacak işlemler
              },
              child: const Text('...'),
            ),
          ],
        ),
      ),
    );
  }
}
