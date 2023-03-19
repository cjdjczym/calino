import 'dart:io';

import 'package:calino/commons/prefs.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/home/home_service.dart';
import 'package:calino/home/report.dart';
import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PicManagePage extends StatefulWidget {
  final PigFuncType type;

  PicManagePage(this.type);

  @override
  State<PicManagePage> createState() => _PicManagePageState();
}

class _PicManagePageState extends State<PicManagePage> {
  List<int> selected = [];

  upload() async {
    if (selected.isEmpty) {
      Toast.show('请至少选择一张图片');
    } else if (widget.type == PigFuncType.IDENTIFY) {
      if (selected.length != 9) {
        Toast.show('缺少${9 - selected.length}张图片，请继续拍摄');
      } else {
        var real = SpUtil.getPics(widget.type).map((e) => '$e').toList();
        await HomeService.uploadPics(real, widget.type);
        real.forEach((e) => SpUtil.delPic(e, widget.type));
        Toast.show('成功上传9张图片');
        selected.clear();
        setState(() {});
      }
    } else {
      var real = selected
          .map((e) => SpUtil.getPics(widget.type)[e - 1].toString())
          .toList();
      await HomeService.uploadPics(real, widget.type);
      real.forEach((e) => SpUtil.delPic(e, widget.type));
      Toast.show('成功上传${selected.length}张图片');
      selected.clear();
      setState(() {});
    }
  }

  Widget item(int index) {
    late Widget content;
    if (index == 0) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/back.png', width: 38.r, height: 40.r),
          SizedBox(height: 5.h),
          Text(
            '取消',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      );
    } else {
      content = Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned.fill(
            child: Image.file(File(SpUtil.getPics(widget.type)[index - 1])),
          ),
          selected.contains(index)
              ? Container(
                  width: 10.r,
                  height: 10.r,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 3, 3, 0),
                  decoration: BoxDecoration(
                    color: Color(0xff18fefe),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '${selected.indexOf(index) + 1}',
                    style: TextStyle(
                      color: Color(0xff00399a),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(
                  width: 10.r,
                  height: 10.r,
                  margin: EdgeInsets.fromLTRB(0, 3, 3, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff18fefe), width: 1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
        ],
      );
    }
    content = Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/border.png', fit: BoxFit.fill),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(.25.sw * 3 / 94),
            child: content,
          ),
        ),
      ],
    );
    return Container(
      width: .25.sw,
      height: .25.sw,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            if (index == 0) {
              setState(() => selected.clear());
            } else if (selected.contains(index)) {
              selected.remove(index);
            } else {
              selected.add(index);
            }
          });
        },
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Temp(
      title: '确认已拍摄图片',
      hasBack: true,
      content: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: SpUtil.getPics(widget.type).length + 1,
              itemBuilder: (_, i) => item(i),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Button(
                press: () {
                  if (selected.isEmpty) {
                    Toast.show('请至少选择一张图片');
                  } else {
                    var copy = [...selected];
                    copy.sort((a, b) => b - a);
                    var real =
                        copy.map((e) => SpUtil.getPics(widget.type)[e - 1]);
                    real.forEach((e) => SpUtil.delPic(e, widget.type));
                    selected.clear();
                    setState(() {});
                  }
                },
                type: ButtonType.EMPTY,
                child: Container(
                  height: 40.h,
                  width: 152.w,
                  alignment: Alignment.center,
                  child: Text('删除',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              Button(
                press: () async => await upload(),
                type: ButtonType.FULL,
                child: Container(
                  height: 40.h,
                  width: 152.w,
                  alignment: Alignment.center,
                  child: Text('确认上传',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
