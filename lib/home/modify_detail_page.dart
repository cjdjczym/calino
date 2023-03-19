import 'package:calino/commons/template.dart';
import 'package:calino/home/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModifyDetailPage extends StatelessWidget {
  final Report report;

  ModifyDetailPage(this.report);

  Widget content(List<Offset> posList, String url, bool after) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 222.h,
        width: 155.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.transparent, Color(0xff60a6ff)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Positioned.fill(
              child: Image.network(
                url,
                fit: BoxFit.cover,
              ),
            ),
            ...posList.map((e) => Positioned(
                  top: 222.h * e.dy - 10.r,
                  left: 155.w * e.dx - 10.r,
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
                      '${posList.indexOf(e) + 1}',
                      style: TextStyle(
                        color: Color(0xff18fefe),
                        fontSize: 12,
                      ),
                    ),
                  ),
                )),
            if (after)
              Container(
                width: 56.w,
                height: 26.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xff18fefe), width: 1),
                  color: Color(0x3318fefe),
                ),
                child: Text(
                  '当前版本',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget itemBuilder(oriList, nowList, String url, CountModify modify) {
    var name = modify.name;
    if (modify.sub) name = '子账户——$name';
    return SizedBox(
      width: 1.sw - 32.w,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 222.h,
            child: Row(
              children: [
                content(oriList, url, false),
                Spacer(),
                content(nowList, url, true),
              ],
            ),
          ),
          Spacer(),
          Text(
            '报告修改时间：${modify.updateAt}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          SizedBox(height: 2.h),
          Text(
            '报告修改账号：$name',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          SizedBox(height: 2.h),
          Text(
            '修改内容：${modify.hint}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var name = report.name;
    if (report.sub) name = '子账户——$name';
    var list = <Widget>[];
    report.countList.forEach((sc) {
      var nowList = [...sc.posList]; // 现在的状态
      sc.modifyList.reversed.forEach((modify) {
        var oriList = [...nowList]; // 原图
        if (modify.isAdd) {
          oriList.removeAt(modify.index);
        } else {
          oriList.insert(modify.index, modify.pos);
        }
        list.add(itemBuilder(oriList, nowList, sc.url, modify));
        nowList = oriList; // 更新原图
      });
    });
    return Temp(
      title: '附录：修改记录',
      hasBack: true,
      content: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '报告上传时间：${report.createAt}',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 8.h),
            Text(
              '报告上传账户：$name',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  width: 159.w,
                  alignment: Alignment.center,
                  child: Text(
                    '原图',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: 159.w,
                  alignment: Alignment.center,
                  child: Text(
                    '修改后',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: list),
              ),
            )
          ],
        ),
      ),
    );
  }
}
