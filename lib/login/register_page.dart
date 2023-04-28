import 'package:calino/commons/route.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/home/home_page.dart';
import 'package:calino/login/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  final int? qrCode;
  final String? sequenceCode;
  final bool sub;

  RegisterPage({this.qrCode, this.sequenceCode, required this.sub});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String phone = '';
  String code = '';
  String pw1 = '';
  String pw2 = '';
  String personName = '';
  String corpName = '';
  String idCard = '';
  bool hasSend = false;
  bool lock = false;

  send() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (phone.isEmpty) {
      Toast.show('请输入手机号');
    } else if (phone.length != 11) {
      Toast.show('手机号格式错误');
    } else {
      await LoginService.getRegisterCaptcha(phone, widget.sub);
      setState(() {
        lock = true;
      });
    }
  }

  check() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (phone.isEmpty) {
      Toast.show('请输入手机号');
    } else if (code.isEmpty) {
      Toast.show('请输入验证码');
    } else if (pw1.isEmpty) {
      Toast.show('请输入密码');
    } else if (!(pw1.length > 8 &&
        RegExp(r'^[A-Za-z0-9]+$').hasMatch(pw1) &&
        !RegExp(r'^[A-Za-z]+$').hasMatch(pw1) &&
        !RegExp(r'^[0-9]+$').hasMatch(pw1))) {
      Toast.show('密码需要由8位以上的数字和字母组成');
    } else if (pw2.isEmpty) {
      Toast.show('请再次输入密码');
    } else if (pw1 != pw2) {
      Toast.show('两次输入密码不一致');
    } else if (personName.isEmpty) {
      Toast.show('请输入姓名');
    } else if (idCard.isEmpty) {
      Toast.show('请输入身份证号');
    } else if (!widget.sub && corpName.isEmpty) {
      Toast.show('请输入养殖场名称');
    } else {
      if (widget.sub) {
        await LoginService.acceptInvitation(
            idCard, pw2, code, phone, personName, pw1);
      } else {
        corpName += '养殖场';
        await LoginService.register(idCard, phone, code, pw1, pw2, personName,
            corpName, widget.sequenceCode!, widget.qrCode!);
      }
      Toast.show('注册成功');
      Ex.pushAndRemoveUntil(context, HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Temp(
      title: '可利农AI猪场',
      hasBack: true,
      hasButton: false,
      content: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
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
            SizedBox(height: 10.h),
            Text('账号', style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5.h),
            Input(
              width: 342.w,
              height: 42.h,
              onChanged: (text) => phone = text,
              hint: '请输入手机号作为账号',
              type: TextInputType.phone,
              tiny: true,
            ),
            SizedBox(height: 10.h),
            Text('验证手机号', style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5.h),
            SizedBox(
              width: 342.w,
              height: 42.h,
              child: Row(
                children: [
                  Input(
                    width: 215.w,
                    height: 42.h,
                    onChanged: (text) => code = text,
                    hint: '请输入验证码',
                    tiny: true,
                  ),
                  Spacer(),
                  lock
                      ? StreamBuilder<int>(
                          stream: Stream.periodic(
                                  Duration(seconds: 1), (time) => time + 1)
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
                                padding:
                                    EdgeInsets.fromLTRB(12.w, 9.h, 12.w, 9.h),
                                child: Text(
                                  '$time秒后重试',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text('密码', style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5.h),
            Input(
              width: 342.w,
              height: 42.h,
              onChanged: (text) => pw1 = text,
              hint: '密码须包含字母和数字，长度至少9位',
              tiny: true,
            ),
            SizedBox(height: 10.h),
            Text('确认密码', style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5.h),
            Input(
              width: 342.w,
              height: 42.h,
              onChanged: (text) => pw2 = text,
              hint: '请再次输入密码',
              tiny: true,
            ),
            SizedBox(height: 10.h),
            Text('身份证号', style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5.h),
            Input(
              width: 342.w,
              height: 42.h,
              onChanged: (text) => idCard = text,
              hint: '请输入身份证号',
              tiny: true,
            ),
            SizedBox(height: 10.h),
            Text('姓名', style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5.h),
            Input(
              width: 342.w,
              height: 42.h,
              onChanged: (text) => personName = text,
              hint: '请输入您的真实姓名，方便同事间交流',
              tiny: true,
            ),
            if (!widget.sub) ...[
              SizedBox(height: 10.h),
              Text('养殖场名称',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 5.h),
              Input(
                width: 342.w,
                height: 42.h,
                onChanged: (text) => corpName = text,
                hint: '请输入养殖场名称',
                tiny: true,
              ),
            ],
            SizedBox(height: 20.h),
            Button(
              press: () async => await check(),
              type: ButtonType.FULL,
              child: Container(
                height: 40.h,
                width: 342.w,
                alignment: Alignment.center,
                child: Text('注册',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
