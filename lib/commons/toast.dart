import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  Toast._();
  static show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 15,
    );
  }
}
