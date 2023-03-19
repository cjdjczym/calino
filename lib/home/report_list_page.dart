import 'dart:math';

import 'package:calino/commons/route.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/home/home_service.dart';
import 'package:calino/home/report.dart';
import 'package:calino/home/report_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportListPage extends StatefulWidget {
  final PigFuncType type;

  ReportListPage(this.type);

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  String selectedDay = '';
  late List<Report> reports = [
    Report(
      '',
      '2022-11-31 16:22:45',
      true,
      '李罡',
      false,
      widget.type,
      [
        SingleCount('', 3, [Offset(.2, .7), Offset(.6, .5), Offset(.3, .3)],
            'https://exp-picture.cdn.bcebos.com/31097f43d7d448318b5fc011d40f822b75ee510e.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1'),
        SingleCount('', 3, [Offset(.2, .7), Offset(.6, .5), Offset(.3, .3)],
            'https://exp-picture.cdn.bcebos.com/31097f43d7d448318b5fc011d40f822b75ee510e.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1'),
      ],
      [
        SingleIdentify('', 'no.1', '2022-11-31 16:22:45', '',
            'https://exp-picture.cdn.bcebos.com/31097f43d7d448318b5fc011d40f822b75ee510e.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1'),
        SingleIdentify('', 'no.2', '2022-11-31 16:22:45', '疑似编号325猪只',
            'https://exp-picture.cdn.bcebos.com/31097f43d7d448318b5fc011d40f822b75ee510e.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1'),
      ],
    ),
    Report(
      '',
      '2022-11-31 16:22:45',
      true,
      '李罡',
      true,
      widget.type,
      [
        SingleCount('', 2, [Offset(.2, .7), Offset(.6, .5)], ''),
        SingleCount('', 2, [Offset(.2, .7), Offset(.6, .5)], ''),
      ],
      [
        SingleIdentify('', 'no.1', '2022-11-31 16:22:45', '', ''),
        SingleIdentify('', 'no.2', '2022-11-31 16:22:45', '疑似编号325猪只', ''),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var reports = await HomeService.getReport(widget.type);
      setState(() {
        this.reports = reports;
      });
    });
  }

  void checkDetail(Report report) {
    var total = 0;
    reports.forEach((r) {
      if (r.createAt.contains(report.day)) {
        r.countList.forEach((c) {
          total += c.count;
        });
      }
    });
    Ex.push(context, ReportDetailPage(report, total)).then((result) {
      if (result != null && result is String) {
        reports = reports.where((e) => e.createAt.contains(result)).toList();
        selectedDay = '（${report.day}）';
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView.separated(
      itemCount: max(10, reports.length + 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            height: 46.h,
            width: 344.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff08b9c1), Color(0xff0758b8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 20.w),
                Text(
                  '上传时间$selectedDay',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Spacer(),
                Container(
                  width: 100.w,
                  height: 46.h,
                  alignment: Alignment.center,
                  child: Text(
                    '操作',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        } else if (index <= reports.length) {
          return Container(
            width: 344.w,
            height: 46.h,
            child: Row(
              children: [
                SizedBox(width: 20.w),
                Text(
                  reports[index - 1].createAt.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Spacer(),
                Container(
                  width: 100.w,
                  height: 46.h,
                  alignment: Alignment.center,
                  child: reports[index - 1].running
                      ? Text(
                          '分析中',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      : Button(
                          press: () => checkDetail(reports[index - 1]),
                          type: ButtonType.HALF,
                          child: Container(
                            height: 28.h,
                            width: 64.w,
                            alignment: Alignment.center,
                            child: Text(
                              '查看报告',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            width: 344.w,
            height: 46.h,
          );
        }
      },
      separatorBuilder: (context, index) {
        return Container(height: 2.h, width: 344.w, color: Color(0xff29f1fa));
      },
    );
    return Temp(
      title: '智能盘点报告',
      hasBack: true,
      content: Column(
        children: [
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 344.w,
              height: 478.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xff60a6ff)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: listView,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
