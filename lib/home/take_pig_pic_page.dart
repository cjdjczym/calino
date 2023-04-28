import 'dart:io';
import 'package:calino/commons/prefs.dart';
import 'package:calino/commons/route.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/home/pic_manage_page.dart';
import 'package:calino/home/report.dart';
import 'package:calino/home/report_list_page.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TakePigPicPage extends StatefulWidget {
  final PigFuncType type;

  TakePigPicPage(this.type);

  @override
  State<TakePigPicPage> createState() => _TakePigPicPageState();
}

class _TakePigPicPageState extends State<TakePigPicPage> {
  late final CameraDescription camera;
  CameraController? ctl;
  File? image;

  static List<String> identifyButtonTexts = [
    '开始拍摄正脸图片',
    '开始拍摄左侧脸图片',
    '开始拍摄右侧脸图片',
    '已拍摄完毕'
  ];

  static List<String> identifyCameraTexts = [
    '请拍摄猪只正脸',
    '请拍摄猪只左侧脸',
    '请拍摄猪只右侧脸',
    '已拍摄完毕'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var cameras = await availableCameras();
      camera = cameras
          .firstWhere((e) => e.lensDirection == CameraLensDirection.back);
      ctl = CameraController(camera, ResolutionPreset.high);
      await ctl!.initialize();
      setState(() {});
    });
  }

  bool running = false;

  tackPicture() async {
    if (ctl == null) return;
    if (running) return;
    running = true;
    XFile file = await ctl!.takePicture();
    if (widget.type == PigFuncType.COUNT) {
      SpUtil.addPic(file.path, widget.type);
    } else {
      var result = Identify.addPic(file.path);
      if (result >= 0) {
        Toast.custom(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/check.png', width: 60, height: 60),
                  SizedBox(height: 20),
                  Text('第${result + 1}只猪拍摄完成',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            positionedToastBuilder: (context, child) {
              return Positioned(
                left: 15,
                right: 15,
                top: 0.4.sh,
                child: child,
              );
            });
      }
    }
    running = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Temp(
      title: widget.type.picTitle,
      hasBack: true,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: 7.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 458.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xcc25d5e3), Color(0x000984ff)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: (ctl == null || !ctl!.value.isInitialized)
                    ? Center(child: CircularProgressIndicator())
                    : Stack(
                        children: [
                          Positioned.fill(child: CameraPreview(ctl!)),
                          if (widget.type == PigFuncType.IDENTIFY)
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/pig${Identify.identifyType + 1}.png',
                                    width: 300.w,
                                    height: 300.h,
                                  ),
                                  Text(
                                      identifyCameraTexts[
                                          Identify.identifyType],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    height: 8,
                                    width: 8 * 5,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Identify.identifyIndex >= 1
                                                ? Colors.blue
                                                : Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Identify.identifyIndex >= 2
                                                ? Colors.blue
                                                : Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Identify.identifyIndex >= 3
                                                ? Colors.blue
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (widget.type == PigFuncType.IDENTIFY &&
                              !Identify.allFinish)
                            Positioned(
                              top: 12.r,
                              right: 12.r,
                              child: Button(
                                press: () {
                                  Identify.clearUnfinished();
                                  setState(() {});
                                },
                                type: ButtonType.HALF,
                                child: Container(
                                  height: 28.h,
                                  width: 54.w,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '重新拍摄',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Button(
                  press: tackPicture,
                  type: ButtonType.FULL,
                  child: Container(
                    height: 40.h,
                    width: 152.w,
                    alignment: Alignment.center,
                    child: Text(
                        widget.type == PigFuncType.COUNT
                            ? '拍摄'
                            : identifyButtonTexts[Identify.identifyType],
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                Spacer(),
                Button(
                  press: () => Ex.push(context, PicManagePage(widget.type))
                      .then((_) => setState(() {})),
                  type: ButtonType.EMPTY,
                  child: Container(
                    height: 40.h,
                    width: 152.w,
                    alignment: Alignment.center,
                    child: Text(
                        widget.type == PigFuncType.COUNT
                            ? '确认已拍摄图片'
                            : '结束拍摄上传至云端',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Button(
              press: () => Ex.push(context, ReportListPage(widget.type)),
              type: ButtonType.FULL,
              child: Container(
                height: 40.h,
                width: 342.w,
                alignment: Alignment.center,
                child: Text('查看报告',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
