import 'package:calino/commons/route.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/user/qr_code_scan_samera_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrCodeScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Temp(
      title: '可利农AI猪场',
      hasBack: true,
      hasButton: false,
      content: ListView(
        children: <Widget>[
          /// 上方标题
          Container(
            margin: EdgeInsets.only(top: 40.h),
            child: ScanIntroTexts(),
          ),

          /// 开启扫描二维码图标
          Container(
            margin: EdgeInsets.only(top: 20.h),
            child: ScanningIcon(),
          ),

          /// 进入扫描摄像头
          Container(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 20.h),
                width: 180.w,
                height: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: const LinearGradient(
                      begin: Alignment(0, -1),
                      end: Alignment(0, 1),
                      colors: [
                        Color.fromRGBO(8, 185, 193, 1),
                        Color.fromRGBO(7, 89, 184, 1)
                      ]),
                ),
                child: TextButton(
                  onPressed: () =>
                      Ex.push(context, QrCodeScanCameraScreen()),
                  child: Text(
                    '我已知晓，开始扫描',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 16.w),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ScanIntroTexts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 8.h),
            child: Text(
              '请扫描比色卡上的',
              style: TextStyle(
                  fontSize: 14.w, color: Color.fromRGBO(255, 255, 255, 0.87)),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 3.h),
            child: Text(
              '定制化二维码',
              style: TextStyle(
                  fontSize: 36.w,
                  color: Color.fromRGBO(255, 255, 255, 0.87),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

        /// 装饰下划线
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 5.h),
            child: Image.asset(
              'assets/user/scan/underlineImg.png',
              height: 4.h,
              width: 280.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 15.h),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: '收到耳标后，请尽快扫描全部二维码，',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.87),
                      fontSize: 13.w,
                      fontWeight: FontWeight.normal)),
              TextSpan(
                  text: '以防系统锁死',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.87),
                      fontSize: 14.w,
                      fontWeight: FontWeight.bold))
            ])),
          ),
        )
      ],
    );
  }
}

class ScanningIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: 284,
            width: 284,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/user/scan/scanningBackground.png',
                    ),
                    fit: BoxFit.contain)),
            child: Text('')));
  }
}
