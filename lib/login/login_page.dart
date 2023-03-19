import 'package:calino/commons/route.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/home/home_page.dart';
import 'package:calino/login/login_service.dart';
import 'package:calino/login/register_page.dart';
import 'package:calino/user/qr_code_scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool codeLogin = true; // 是否使用验证码登录
  String phone = ''; // 账号 / 手机号
  String code = ''; // 密码 / 验证码
  bool hasSend = false;
  bool lock = false;

  send() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (phone.isEmpty) {
      Toast.show('请输入账号/手机号');
    } else if (phone.length != 11) {
      Toast.show('手机号格式错误');
    } else {
      await LoginService.getLoginCaptcha(phone);
      setState(() {
        lock = true;
      });
    }
  }

  check() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (phone.isEmpty) {
      Toast.show('请输入账号/手机号');
    } else if (code.isEmpty && codeLogin) {
      Toast.show('请输入验证码');
    } else if (code.isEmpty && !codeLogin) {
      Toast.show('请输入密码');
    } else {
      if (codeLogin)
        await LoginService.codeLogin(phone, code);
      else
        await LoginService.pwLogin(phone, code);
      Ex.pushAndRemoveUntil(context, HomePage());
    }
  }

  Widget get secondInput {
    if (!codeLogin) {
      return Input(onChanged: (text) => code = text, hint: '请输入密码');
    }
    return SizedBox(
      width: 300.w,
      height: 52.h,
      child: Row(
        children: [
          Input(
            width: 170.w,
            onChanged: (text) => code = text,
            hint: '请输入验证码',
            tiny: true,
          ),
          Spacer(),
          lock
              ? StreamBuilder<int>(
                  stream:
                      Stream.periodic(Duration(seconds: 1), (time) => time + 1)
                          .take(60),
                  builder: (context, snap) {
                    var time = 60 - (snap.data ?? 0);
                    if (time == 0) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          lock = false;
                          hasSend = true;
                        });
                      });
                    }
                    return Button(
                      press: () {},
                      type: ButtonType.HALF,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12.w, 9.h, 12.w, 9.h),
                        child: Text(
                          '$time秒后重试',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    );
                  })
              : Button(
                  press: () async => await send(),
                  type: ButtonType.HALF,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12.w, 9.h, 12.w, 9.h),
                    child: Text(
                      hasSend ? '重新发送' : '获取验证码',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Temp(
      title: '可利农AI猪场',
      hasButton: false,
      content: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Image.asset(
              'assets/logo.png',
              width: 280.w,
              height: 60.h,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10.h),
            Container(
              width: 280.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Color(0xff1b7ef2),
                boxShadow: [
                  BoxShadow(color: Color(0xcc1b7ef2), blurRadius: 10)
                ],
              ),
            ),
            SizedBox(height: 35.h),
            Text('账号/手机号码',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 15.h),
            Input(
              onChanged: (text) => phone = text,
              hint: '请输入号码',
              type: TextInputType.phone,
            ),
            SizedBox(height: 25.h),
            Text(codeLogin ? '验证码' : '密码',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 15.h),
            secondInput,
            SizedBox(height: 35.h),
            GestureDetector(
              onTap: () => setState(() => codeLogin = !codeLogin),
              child: Text(codeLogin ? '使用账号密码登录' : '使用短信验证码登录',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
            SizedBox(height: 15.h),
            Button(
              press: () async => await check(),
              type: ButtonType.FULL,
              child: Container(
                height: 40.h,
                width: 342.w,
                alignment: Alignment.center,
                child: Text('登录',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Button(
                  press: () => Ex.push(context, QrCodeScanScreen()),
                  type: ButtonType.FULL,
                  child: Container(
                    height: 40.h,
                    width: 152.w,
                    alignment: Alignment.center,
                    child: Text('注册主账号',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                Button(
                  press: () => Ex.push(context, RegisterPage(sub: true)),
                  type: ButtonType.EMPTY,
                  child: Container(
                    height: 40.h,
                    width: 152.w,
                    alignment: Alignment.center,
                    child: Text('注册子账号',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
