import 'package:flutter/material.dart';
import 'package:login_screen/views/profile_screen/profile_screen.dart';
import 'package:login_screen/views/vehicle_screen/vehicle_screen.dart';
import 'package:login_screen/widgets/custom_buton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Ekran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              // Ayarlar butonuna basıldığında yapılacak işlemler
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Hoşgeldiniz", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
              Image.asset("assets/images/City driver-pana.png"),
              CustomButon(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VehicleSecreen()),
                  ); // "Araç Seç" butonuna basıldığında yapılacak işlemler
                },
                width: 200,
                child: const Text("Araç Seç", style:  TextStyle(fontSize: 18, color: Colors.white)),
              ),
              CustomButon(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VehicleSecreen()),
                  ); // "Araç Seç" butonuna basıldığında yapılacak işlemler
                },
                width: 200,
                child: const Text("Randevularım", style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
