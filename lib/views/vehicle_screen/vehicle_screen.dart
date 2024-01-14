import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/vehicle_model.dart';
import 'package:login_screen/themes/light_theme.dart';
import 'package:login_screen/utils/constants.dart';
import 'package:login_screen/views/vehicle_screen/controller/vehicle_controller.dart';
import 'package:login_screen/views/vehicle_screen/widgets/vehicle_detail_cart.dart';
import 'package:login_screen/widgets/custom_buton.dart';
import 'package:login_screen/widgets/custom_textField.dart';
import 'package:login_screen/widgets/wating_widgets.dart';

class VehicleSecreen extends StatelessWidget {
  const VehicleSecreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Consumer(builder: (context, ref, child) {
            final controller = ref.read(vehicleController);
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                final seciliArac = controller.seciliArac;
                if (seciliArac == null) {
                  Navigator.pop(context);
                  return;
                }
                Navigator.pop(context, seciliArac.toJson());
                // Ayarlar butonuna basıldığında yapılacak işlemler
              },
            );
          }),
          title: const Text("Araçlar"),
        ),
        floatingActionButton: Consumer(builder: (context, ref, child) {
          final controller = ref.read(vehicleController);
          return aracEklemeButonu(context, controller, ref);
        }),
        body: Consumer(builder: (context, ref, child) {
          final controller = ref.read(vehicleController);

          return StreamBuilder<QuerySnapshot>(
              stream: controller.getVehicles(),
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

                List<VehicleModel> data = snapshot.data!.docs.map((e) => VehicleModel.fromJson(e.data() as Map<String, dynamic>)).toList();
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return VehicleDetailCart(model: data[index]);
                    });
              });
        }));
  }

  FloatingActionButton aracEklemeButonu(BuildContext context, VehicleController controller, WidgetRef ref) {
    return FloatingActionButton(
        backgroundColor: Themes.primaryColor,

        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      height: 10,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Araç Kaydı",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          )),
                    ),
                    CustomTextField(hintText: "Araç Adı", controller: controller.nameController),
                    CustomTextField(hintText: "Plaka", controller: controller.plakaController),

                    /*PopupMenuButton(,itemBuilder: (context) {

                          return [
                            ...List.generate(
                              vehicleTypes.length,
                              (index) => PopupMenuItem(
                                child: Text(vehicleTypes[index]),
                              ),
                            )
                          ];
                        }),*/
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black.withOpacity(0.5)),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: controller.pageController,
                          itemCount: vehicleTypes.length,
                          onPageChanged: (index) {
                            ref.watch(vehicleController).aktifIndexiAta(index);
                          },
                          itemBuilder: (context, index) {
                            String data = vehicleTypes[index];
                            return Center(child: Text(data, style: const TextStyle(fontSize: 18)));
                          },
                        ),
                      ),
                    ),
                    Spacer(),
                    CustomButon(
                      height: 50,
                      width: 200,
                      onTap: () {
                        controller.addVehicle();
                        //TODO : İŞlem Başarlı ise animasyon göster
                        Navigator.pop(context);
                      },
                      child: const Text("Kaydet", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
