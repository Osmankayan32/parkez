import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ExSnacBar {
  static void show(String message, {Color? color, Function()? onTap, Duration? duration, BuildContext? context}) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(_snacBar(message, color: color, onTap: onTap, duration: duration));
    }
    scaffoldMessengerKey.currentState?.showSnackBar(_snacBar(message, color: color, onTap: onTap, duration: duration));
  }

  static SnackBar _snacBar(String message, {Color? color, Function()? onTap, Duration? duration}) {
    return SnackBar(
      backgroundColor: Colors.transparent, // Snackbar'ın arka planını transparan yapın
      elevation: 0, // Snackbar'ın yükseliğini sıfıra ayarlayın
      duration: duration ?? const Duration(seconds: 2),
      content: InkWell(
        onTap: onTap,
        child: Container(
// Bulanık arka plan için bir konteyner kullanın
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(1), // Bulanıklık için bir renk ve opaklık ayarlayın

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            message,
            style: TextStyle(
              color: color == null ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}