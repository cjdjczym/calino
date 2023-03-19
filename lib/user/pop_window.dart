import 'package:calino/commons/route.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/user/temp_admin_page.dart';
import 'package:calino/user/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 修改姓名
void openModifyName(
    {required BuildContext context,
    required String headline,
    required ValueChanged<String> onChange}) {
  String name = '';
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(headline),
          content: Card(
              color: Color.fromRGBO(196, 204, 212, 1),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '请输入新昵称',
                  hintStyle: TextStyle(color: Color(0x99000000)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(fontSize: 14, color: Colors.black),
                enabled: true,
                maxLines: 1,
                textAlign: TextAlign.center,
                // 监听变化
                onChanged: ((value) {
                  name = value;
                }),
              )),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Ex.pop(context),
              child: Text('取消'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                if (name == '') {
                  Toast.show('昵称不能为空');
                  return;
                }
                await UserService.modifyName(name);
                Toast.show('修改成功');
                onChange(name);
                Ex.pop(context);
              },
              child: Text('确定'),
            ),
          ],
        );
      });
}

/// 修改备注名
void openModifyRemark(
    {required BuildContext context,
    required String headline,
    required farmId,
    required userId}) {
  String name = '';
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(headline),
          content: Card(
              color: Color.fromRGBO(196, 204, 212, 1),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '请输入新备注',
                  hintStyle: TextStyle(color: Color(0x99000000)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(fontSize: 14, color: Colors.black),
                enabled: true,
                maxLines: 1,
                textAlign: TextAlign.center,
                // 监听变化
                onChanged: ((value) {
                  name = value;
                }),
              )),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                if (name == '') {
                  Toast.show('备注不能为空');
                  return;
                }
                await UserService.modifyRemarkMember(farmId, userId, name);
                Toast.show('修改成功');
                Ex.pop(context);
                Ex.pushReplacement(context, TeamAdminScreen());
              },
              child: Text('确定'),
            ),
          ],
        );
      });
}

void openOfficialWechatQrcode({required BuildContext context}) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            content: Container(
              width: 225,
              height: 225,
              child: Image.asset(
                'assets/user/userCenter/calinoWechat.png',
                fit: BoxFit.cover,
              ),
            ),
          ));
}
