import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExCupertinoDatePicker {
  static Future<void> showPicker(
    BuildContext context, {
    required void Function(DateTime dateTime) onDateTimeChanged,
    DateTime? minimumDate,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
    required void Function() selectFunction,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  minimumDate: minimumDate,
                  maximumDate: DateTime.now().add(const Duration(days: 365)),
                  mode:mode,
                  use24hFormat: true,
                  onDateTimeChanged: onDateTimeChanged,
                ),
              ),
              SafeArea(
                top: false,
                child: TextButton(
                  onPressed: selectFunction,
                  child: const Text('Seç'),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
