import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

class ToastService {
  static final FToast fToast = FToast();

  static void showToast(String message, {bool? isSuccess}) {
    fToast.init(navigatorKey.currentState!.context);

    // Determine the style based on isSuccess
    Color backgroundColor;
    IconData? icon;

    if (isSuccess == true) {
      backgroundColor = Colors.greenAccent;
      icon = Icons.check;
    } else if (isSuccess == false) {
      backgroundColor = Colors.redAccent;
      icon = Icons.close;
    } else {
      backgroundColor = Colors.grey;
      icon = null;
    }

    // Create the toast widget
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12.0),
          ],
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    // Show the toast
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
