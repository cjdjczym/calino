import 'package:calino/commons/route.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 子账号邀请页 √
class InviteScreen extends StatefulWidget {
  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  String mobile = '';

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
              margin: EdgeInsets.only(top: 51.h),
              height: 150.h,
              child: Image.asset(
                'assets/user/calinoLogo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 14.h),
              child: Text(
                '成员手机号',
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1), fontSize: 18.w),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 28.h),
              width: 262.w,
              height: 52.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/user/inputBackground.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Center(
                child: Container(
                    margin: EdgeInsets.only(bottom: 9.h),
                    width: 200.w,
                    height: 52.h,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        LengthLimitingTextInputFormatter(11),
                      ],
                      decoration: InputDecoration(
                        hintText: '请输入待邀请子账号的手机号',
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                        border: InputBorder.none, // 去掉下滑线
                        counterText: '', // 去除输入框底部的字符计数
                      ),
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 12.w,
                      ),
                      // 是否启动输入框
                      keyboardType: TextInputType.number,
                      enabled: true,
                      maxLines: 1,
                      maxLength: 11,
                      textAlign: TextAlign.center,
                      // 监听变化
                      onChanged: ((value) {
                        mobile = value;
                      }),
                    )),
              ),
            ),
          ),

          /// 注册、登录按钮
          Container(
            margin: EdgeInsets.only(top: 51.h),
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
                      onPressed: () => Navigator.pop(context),
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
                        if (mobile.length != 11) {
                          Toast.show('手机号格式错误');
                          return;
                        }
                        await UserService.inviteMember(mobile);
                        Toast.show('邀请成功，1s 后将自动回退到子账号管理页');
                        Future.delayed(
                            Duration(seconds: 1), () => Ex.pop(context));
                      },
                      child: Text(
                        '邀请',
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
