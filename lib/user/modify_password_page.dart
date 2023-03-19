import 'package:calino/commons/route.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/login/login_page.dart';
import 'package:calino/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 修改密码
class ModifyPasswordScreen extends StatefulWidget {
  @override
  State<ModifyPasswordScreen> createState() => _ModifyPasswordScreenState();
}

class _ModifyPasswordScreenState extends State<ModifyPasswordScreen> {
  String oldPassword = '';
  String password = '';
  String checkPassword = '';

  @override
  Widget build(BuildContext context) {
    return Temp(
      title: '可利农AI猪场',
      hasBack: true,
      hasButton: false,
      content: ListView(
        children: [
          /// CALINO LOGO
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 25.h),
              height: 150.h,
              child: Image.asset(
                'assets/user/calinoLogo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// 旧密码
          Center(
            child: Container(
              child: Text(
                '旧密码',
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1), fontSize: 16.w),
              ),
            ),
          ),

          /// 原始密码输入
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 14.h),
              width: 262.w,
              height: 50.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/user/inputBackground.png'),
                      fit: BoxFit.contain)),
              child: Center(
                child: Container(
                    width: 200.w,
                    height: 50.h,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '请输入旧密码',
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                        border: InputBorder.none, // 去掉下滑线
                        counterText: '', // 去除输入框底部的字符计数
                      ),
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 14.w,
                      ),
                      // 是否启动输入框
                      enabled: true,
                      maxLines: 1,
                      maxLength: 11,
                      textAlign: TextAlign.center,
                      onChanged: ((value) => oldPassword = value),
                    )),
              ),
            ),
          ),

          /// 新密码
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 25.h),
              child: Text(
                '新密码',
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1), fontSize: 16.w),
              ),
            ),
          ),

          /// 新密码输入
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 14.h),
              width: 262.w,
              height: 50.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/user/inputBackground.png'),
                      fit: BoxFit.contain)),
              child: Center(
                child: Container(
                    width: 200.w,
                    height: 50.h,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '请输入新密码',
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                        border: InputBorder.none, // 去掉下滑线
                        counterText: '', // 去除输入框底部的字符计数
                      ),
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 14.w,
                      ),
                      // 是否启动输入框
                      enabled: true,
                      textAlign: TextAlign.center,
                      // 监听变化
                      onChanged: ((value) => password = value),
                    )),
              ),
            ),
          ),

          /// 确认密码
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 25.h),
              child: Text(
                '确认密码',
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1), fontSize: 16.w),
              ),
            ),
          ),

          /// 新密码输入
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 14.h),
              width: 262.w,
              height: 50.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/user/inputBackground.png'),
                      fit: BoxFit.contain)),
              child: Center(
                child: Container(
                    width: 200.w,
                    height: 50.h,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '请再次输入新密码',
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 14.w,
                      ),
                      // 是否启动输入框
                      enabled: true,
                      textAlign: TextAlign.center,
                      // 监听变化
                      onChanged: ((value) => checkPassword = value),
                    )),
              ),
            ),
          ),

          /// 取消、确认修改
          Container(
            margin: EdgeInsets.only(top: 25.h),
            child: SizedBox(
              height: 40.h,
              width: 500.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 152.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(51, 254, 254, 1), width: 1),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '取消',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 16.w),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 38.w),
                    width: 152.w,
                    height: 40.h,
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
                      onPressed: () async {
                        if (oldPassword.length <= 6 ||
                            !RegExp(r'^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,24}$')
                                .hasMatch(oldPassword)) {
                          Toast.show('旧密码有误');
                          return;
                        }
                        if (password.length <= 6 ||
                            !RegExp(r'^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,24}$')
                                .hasMatch(password)) {
                          Toast.show('新密码格式不符合');
                          return;
                        }
                        if (password.compareTo(checkPassword) != 0) {
                          Toast.show('两次密码不匹配');
                          return;
                        }
                        await UserService.modifyPassword(
                            oldPassword, password, checkPassword);
                        Toast.show('密码修改成功，请重新登录');
                        await UserService.logout();
                        Ex.pushAndRemoveUntil(context, LoginPage());
                      },
                      child: Text(
                        '确认修改',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 16.w),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
