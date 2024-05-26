import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomshett {

  static void show({required BuildContext context, required Widget child}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      // yüksekliği 0.9 yaparak ekranın %90'ını kaplayacak şekilde ayarladık

      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,

            ),
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}