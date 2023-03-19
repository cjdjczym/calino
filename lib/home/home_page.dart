import 'package:calino/commons/route.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/home/report.dart';
import 'package:calino/home/take_pig_pic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Temp(
      title: '可利农AI猪场',
      content: Column(
        children: [
          Spacer(flex: 1),
          Text('功能选择',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Spacer(flex: 2),
          Button(
            press: () {
              Toast.show('暂未实现');
            },
            type: ButtonType.FULL,
            child: Container(
              height: 40.h,
              width: 342.w,
              alignment: Alignment.center,
              child: Text('AI测耳温',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Spacer(flex: 2),
          Button(
            press: () => Ex.push(context, TakePigPicPage(PigFuncType.COUNT)),
            type: ButtonType.FULL,
            child: Container(
              height: 40.h,
              width: 342.w,
              alignment: Alignment.center,
              child: Text('猪只数目智能盘点',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Spacer(flex: 2),
          Button(
            press: () => Ex.push(context, TakePigPicPage(PigFuncType.IDENTIFY)),
            type: ButtonType.FULL,
            child: Container(
              height: 40.h,
              width: 342.w,
              alignment: Alignment.center,
              child: Text('猪只唯一化识别',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Spacer(flex: 4),
        ],
      ),
    );
  }
}
