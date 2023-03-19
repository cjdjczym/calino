import 'package:calino/commons/route.dart';
import 'package:calino/login/register_page.dart';
import 'package:calino/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanCameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cameraController = MobileScannerController();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/user/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: ListView(
            children: [
              QrCodeCameraHeadComponent(
                title: '账号续费二维码验证',
                cameraController: cameraController,
              ),
              Container(
                height: 695.h,
                child: MobileScanner(
                    allowDuplicates: false,
                    controller: cameraController,
                    onDetect: (barcode, args) async {
                      if (barcode.rawValue == null) return;
                      final String sequenceCode = barcode.rawValue!;
                      var qrCode = await UserService.checkQrCode(sequenceCode);
                      Ex.push(
                        context,
                        RegisterPage(
                          qrCode: qrCode,
                          sequenceCode: sequenceCode,
                          sub: false,
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QrCodeCameraHeadComponent extends StatefulWidget {
  QrCodeCameraHeadComponent(
      {required this.title, required this.cameraController});

  final String title;
  final MobileScannerController cameraController;

  @override
  State<QrCodeCameraHeadComponent> createState() =>
      _QrCodeCameraHeadComponentState(
          title: title, cameraController: cameraController);
}

class _QrCodeCameraHeadComponentState extends State<QrCodeCameraHeadComponent> {
  _QrCodeCameraHeadComponentState(
      {required this.title, required this.cameraController}) {
    _flag = this.cameraController.hasTorch;
  }

  String title;
  MobileScannerController cameraController;
  bool _flag = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/user/headBackground.png'),
            fit: BoxFit.fill),
      ),
      height: 56.41.h,
      width: 812.w,
      child: Stack(
        children: [
          Positioned(
              left: 10.w,
              top: 7.h,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(24, 254, 254, 1),
                    size: 26.w,
                  ))),
          Center(
            child: Text(
              title,
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.w),
            ),
          ),
          // 关灯
          Positioned(
            right: 10.w,
            top: 7.h,
            child: TextButton(
              onPressed: () {
                cameraController.toggleTorch();
                setState(() {
                  _flag = !_flag;
                });
              },
              child: Image.asset(
                _flag
                    ? 'assets/user/scan/lightOn.png'
                    : 'assets/user/scan/lightOff.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
