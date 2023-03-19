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

  tackPicture() async {
    if (widget.type == PigFuncType.IDENTIFY && SpUtil.identifyFull) return;
    if (ctl == null) return;
    XFile file = await ctl!.takePicture();
    Toast.show('拍摄了一张照片');
    SpUtil.addPic(file.path, widget.type);
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
                          if (widget.type == PigFuncType.IDENTIFY &&
                              !SpUtil.identifyFull)
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/pig${SpUtil.identifyIndex + 1}.png',
                                    width: 199.w,
                                    height: 283.h,
                                  ),
                                  Text(
                                      identifyCameraTexts[SpUtil.identifyIndex],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ],
                              ),
                            ),
                          if (widget.type == PigFuncType.IDENTIFY &&
                              !SpUtil.identifyEmpty)
                            Positioned(
                              top: 12.r,
                              right: 12.r,
                              child: Button(
                                press: () {
                                  SpUtil.identifyClear();
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
                            : identifyButtonTexts[SpUtil.identifyIndex],
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
