import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/models/vehicle_model.dart';
import 'package:login_screen/views/vehicle_screen/controller/vehicle_controller.dart';

import '../../../themes/light_theme.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_buton.dart';
import '../../../widgets/custom_textField.dart';

class VehicleDetailCart extends StatefulWidget {
  final VehicleModel model;

  const VehicleDetailCart({Key? key, required this.model}) : super(key: key);

  @override
  State<VehicleDetailCart> createState() => _VehicleDetailCartState();
}

class _VehicleDetailCartState extends State<VehicleDetailCart> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController plakaController = TextEditingController();
  late final PageController pageController;

  @override
  void initState() {
    nameController.text = widget.model.aracName ?? "";
    plakaController.text = widget.model.plaka ?? "";

    int key = vehicleTypes.keys.firstWhere((key) => vehicleTypes[key] == widget.model.aracType);
    pageController = PageController(initialPage: key);
    super.initState();
  }

  Widget aracTuruneGoreIconAta(String? aracType) {
    if (VehicleTypes.otomobil == aracType) {
      return const Icon(Icons.car_crash);
    }
    if (VehicleTypes.motosiklet == aracType) {
      return const Icon(Icons.motorcycle);
    }
    return const Icon(Icons.motorcycle);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final controller = ref.read(vehicleController);

      final seciliArac = ref.watch(vehicleController.select((value) => value)).seciliArac;
      String aracPlaka = seciliArac?.plaka ?? "null";
      return ListTile(
        selected: aracPlaka == widget.model.plaka,
        onTap: () {
          controller.selectVehicle(widget.model);
          Navigator.pop(context, widget.model.toJson());
          // Araç detayına git
        },
        leading: CircleAvatar(child: aracTuruneGoreIconAta(widget.model.aracType)),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
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
                            alignment: Alignment.centerLeft, child: Text("Araç Kaydı", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
                      ),
                      CustomTextField(hintText: "Araç Adı", controller: nameController),
                      CustomTextField(hintText: "Plaka", controller: plakaController),
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
                            controller: pageController,
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
                      Row(
                        children: [
                          Expanded(
                            child: CustomButon(
                              height: 50,
                              color: Colors.red,
                              onTap: () {
                                controller.removeVehicle(widget.model.plaka!);
                                //TODO : İŞlem Başarlı ise animasyon göster
                                Navigator.pop(context);
                              },
                              child: const Text("Sil", style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ),
                          Expanded(
                            child: CustomButon(
                              height: 50,
                              onTap: () {
                                controller.updateVehicle(
                                  VehicleModel(
                                    aracName: nameController.text,
                                    plaka: plakaController.text,
                                    aracType: vehicleTypes[controller.vehicleType],
                                    uid: widget.model.uid,
                                    id: widget.model.id,
                                  ),
                                );
                                //TODO : İŞlem Başarlı ise animasyon göster
                                Navigator.pop(context);
                              },
                              child: const Text("Kaydet", style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
        title: Text(widget.model.aracName ?? "null"),
        subtitle: Text(widget.model.plaka ?? "null"),
      );
    });
  }
}
