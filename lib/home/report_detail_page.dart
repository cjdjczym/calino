import 'package:calino/commons/prefs.dart';
import 'package:calino/commons/route.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/home/home_service.dart';
import 'package:calino/home/modify_detail_page.dart';
import 'package:calino/home/report.dart';
import 'package:calino/user/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportDetailPage extends StatefulWidget {
  final Report report;
  final int todayCount;

  ReportDetailPage(this.report, this.todayCount);

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  bool enableAdd = false;
  bool enableDel = false;

  Widget get count {
    var total = 0;
    widget.report.countList.forEach((e) {
      total += e.count;
    });
    var itemBuilder = (_, index) {
      return SizedBox(
        height: 204.h,
        width: 344.w,
        child: Row(
          children: [
            Builder(builder: (context) {
              return GestureDetector(
                onTapDown: (TapDownDetails detail) async {
                  var user = UserData.fromRawJson(SpUtil.userData.value);
                  var sub = user.manager.managerMobile == user.userInfo.mobile;
                  var count = widget.report.countList[index];
                  var renderBox = context.findRenderObject() as RenderBox;
                  var localPos = renderBox.globalToLocal(detail.globalPosition);
                  if (enableAdd) {
                    var dx = (localPos.dx - 10.r) / 146.w;
                    var dy = (localPos.dy - 10.r) / 204.h;
                    await HomeService.modifyReport(
                        count.id, true, count.posList.length, dx, dy);
                    count.modifyList.add(CountModify(
                        formatDate(DateTime.now()),
                        user.userInfo.nickname,
                        sub,
                        Offset(dx, dy),
                        count.posList.length,
                        true));
                    count.posList.add(Offset(dx, dy));
                    enableAdd = false;
                    setState(() {});
                  }
                  if (enableDel) {
                    var x = localPos.dx, y = localPos.dy;
                    for (int i = count.posList.length - 1; i >= 0; i--) {
                      var x1 = 146.w * count.posList[i].dx - 20.r,
                          x2 = x1 + 40.r;
                      var y1 = 204.h * count.posList[i].dy - 20.r,
                          y2 = y1 + 40.r;
                      if (x1 < x && x < x2 && y1 < y && y < y2) {
                        await HomeService.modifyReport(
                            count.id,
                            false,
                            count.posList.length,
                            count.posList[i].dx,
                            count.posList[i].dy);
                        count.modifyList.add(CountModify(
                            formatDate(DateTime.now()),
                            user.userInfo.nickname,
                            sub,
                            count.posList[i],
                            i,
                            false));
                        count.posList.removeAt(i);
                        enableDel = false;
                        setState(() {});
                        return;
                      }
                    }
                    enableDel = false;
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 204.h,
                    width: 146.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xff60a6ff)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            widget.report.countList[index].url,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ...widget.report.countList[index].posList
                            .map((e) => Positioned(
                                  top: 204.h * e.dy - 10.r,
                                  left: 146.w * e.dx - 10.r,
                                  child: Container(
                                    height: 20.r,
                                    width: 20.r,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Color(0xff18fefe),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '${widget.report.countList[index].posList.indexOf(e) + 1}',
                                      style: TextStyle(
                                        color: Color(0xff18fefe),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )),
                        Positioned(
                          top: 12.r,
                          right: 12.r,
                          child: CupertinoButton(
                            onPressed: () async {
                              await HomeService.deletePic(
                                  widget.report.countList[index].id);
                              widget.report.countList.removeAt(index);
                              setState(() {});
                            },
                            padding: EdgeInsets.zero,
                            child: Image.asset(
                              'assets/delete.png',
                              width: 17.r,
                              height: 17.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            SizedBox(width: 15.w),
            Spacer(),
            SizedBox(
              height: 204.h,
              width: 93.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '共${widget.report.countList[index].count}只猪',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Button(
                    press: () {
                      enableAdd = true;
                      enableDel = false;
                    },
                    type: ButtonType.HALF,
                    child: Container(
                      height: 40.h,
                      width: 93.w,
                      alignment: Alignment.center,
                      child: Text(
                        '手动添加',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  Button(
                    press: () {
                      enableAdd = false;
                      enableDel = true;
                    },
                    type: ButtonType.HALF,
                    child: Container(
                      height: 40.h,
                      width: 93.w,
                      alignment: Alignment.center,
                      child: Text(
                        '手动删除',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      );
    };
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: widget.report.countList.length,
            itemBuilder: itemBuilder,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '本次共识别猪只$total头，本日共识别猪只${widget.todayCount}头',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        SizedBox(height: 10.h),
        Button(
          press: () {
            Toast.show('上传报告成功');
          },
          type: ButtonType.FULL,
          child: Container(
            height: 40.h,
            width: 342.w,
            alignment: Alignment.center,
            child: Text('上传报告',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Button(
              press: () => Ex.push(context, ModifyDetailPage(widget.report)),
              type: ButtonType.EMPTY,
              child: Container(
                height: 40.h,
                width: 152.w,
                alignment: Alignment.center,
                child: Text('查看修改记录',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            Spacer(),
            Button(
              press: () => Ex.pop(context, widget.report.day),
              type: ButtonType.FULL,
              child: Container(
                height: 40.h,
                width: 152.w,
                alignment: Alignment.center,
                child: Text('查看当日汇总报告',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get identify {
    var itemBuilder = (context, index) {
      return SizedBox(
        height: 222.h,
        width: 344.w,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 222.h,
                width: 159.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xff60a6ff)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        widget.report.identifyList[index].url,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 1.r,
                      bottom: 1.r,
                      right: 4.r,
                      child: Image.asset(
                        'assets/right.png',
                        width: 11.r,
                        height: 21.r,
                      ),
                    ),
                    Positioned(
                      top: 1.r,
                      bottom: 1.r,
                      left: 4.r,
                      child: Image.asset(
                        'assets/left.png',
                        width: 11.r,
                        height: 21.r,
                      ),
                    ),
                    Positioned(
                      top: 12.r,
                      right: 12.r,
                      child: CupertinoButton(
                        onPressed: () async {
                          await HomeService.deletePic(
                              widget.report.identifyList[index].id);
                          widget.report.identifyList.removeAt(index);
                          setState(() {});
                        },
                        padding: EdgeInsets.zero,
                        child: Image.asset(
                          'assets/delete.png',
                          width: 17.r,
                          height: 17.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    '耳标号：${widget.report.identifyList[index].no}',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '采集时间：${widget.report.identifyList[index].time}',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '情况说明：${widget.report.identifyList[index].hint}',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Image.asset(
                        widget.report.identifyList[index].hint == ''
                            ? 'assets/check.png'
                            : 'assets/warn.png',
                        width: 20.r,
                        height: 20.r,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        widget.report.identifyList[index].hint == ''
                            ? '正常'
                            : widget.report.identifyList[index].hint,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    };

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: widget.report.identifyList.length,
            itemBuilder: itemBuilder,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
          ),
        ),
        SizedBox(height: 20.h),
        Button(
          press: () => Ex.pop(context, widget.report.day),
          type: ButtonType.FULL,
          child: Container(
            height: 40.h,
            width: 342.w,
            alignment: Alignment.center,
            child: Text('查看当日汇总报告',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var name = widget.report.name;
    if (widget.report.sub) name = '子账户——$name';
    return Temp(
      title: widget.report.type.detailTitle,
      hasBack: true,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              '报告上传时间：${widget.report.createAt}',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 8.h),
            Text(
              '报告上传账户：$name',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: widget.report.type == PigFuncType.COUNT ? count : identify,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
