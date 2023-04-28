import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Toast {
  Toast._();

  static late FToast _fToast;

  static void init(BuildContext context) {
    _fToast = FToast().init(context);
  }

  static show(String msg) {
    Toast.custom(
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          msg,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      positionedToastBuilder: (context, child) {
        return Positioned(
          left: 16.0, // 左右填一样的值可以居中
          right: 16.0,
          bottom: 0.1.sh,
          child: child,
        );
      },
    );
  }

  static void custom({
    required Widget child,
    Duration duration = const Duration(seconds: 2),
    PositionedToastBuilder? positionedToastBuilder,
  }) {
    if (positionedToastBuilder != null) {
      _fToast.showToast(
        child: child,
        toastDuration: duration,
        positionedToastBuilder: positionedToastBuilder,
      );
    } else {
      _fToast.showToast(
        child: child,
        toastDuration: duration,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
