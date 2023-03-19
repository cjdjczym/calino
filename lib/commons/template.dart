import 'dart:ui' as ui;
import 'package:calino/commons/route.dart';
import 'package:calino/user/user_center_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Temp extends StatefulWidget {
  final bool hasBack;
  final bool hasButton;
  final String title;
  final Widget content;

  Temp({
    this.hasBack = false,
    this.hasButton = true,
    required this.title,
    required this.content,
  });

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  bool left = true;

  final styleE = TextStyle(
    fontSize: 10,
    foreground: Paint()
      ..shader = ui.Gradient.linear(
        const Offset(50, 0),
        const Offset(50, 20),
        [Color(0xff08b9c1), Color(0xff0758b8)],
      ),
  );
  final styleN = TextStyle(
    fontSize: 10,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Container(
              height: 65.h,
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/top.png'),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.hasBack)
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 16.w),
                      child: Back(),
                    ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/mid.png'),
                  ),
                ),
                child: left ? widget.content : UserCenterScreen(),
              ),
            ),
            Container(
              height: 70.h,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/bottom.png'),
                ),
              ),
              child: widget.hasButton ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CupertinoButton(
                    onPressed: () => setState(() => left = true),
                    padding: EdgeInsets.all(8.r),
                    child: SizedBox(
                      height: 42.h,
                      child: Column(
                        children: [
                          Image.asset(
                            left
                                ? 'assets/feat_en.png'
                                : 'assets/feat.png',
                            width: 26.r,
                            height: 26.r,
                          ),
                          Spacer(),
                          Text('功能选择', style: left ? styleE : styleN),
                        ],
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () => setState(() => left = false),
                    padding: EdgeInsets.all(8.r),
                    child: SizedBox(
                      height: 42.h,
                      child: Column(
                        children: [
                          Image.asset(
                            left
                                ? 'assets/user.png'
                                : 'assets/user_en.png',
                            width: 26.r,
                            height: 26.r,
                          ),
                          Spacer(),
                          Text('个人中心', style: left ? styleN : styleE),
                        ],
                      ),
                    ),
                  ),
                ],
              ) : Container(),
            )
          ],
        ),
      ),
    );
  }
}

class Back extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Button(
        press: () => Ex.pop(context),
        type: ButtonType.HALF,
        child: Container(
          height: 28.h,
          width: 54.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.arrow_back_ios_new, size: 12, color: Colors.white),
              Text('返回', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

enum ButtonType { FULL, HALF, EMPTY }

final _full = BoxDecoration(
  borderRadius: BorderRadius.circular(12),
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff08b9c1), Color(0xff0758b8)],
  ),
);
final _half = BoxDecoration(
  borderRadius: BorderRadius.circular(4),
  border: Border.all(color: Color(0xff18fefe), width: 1),
  color: Color(0x3318fefe),
);
final _empty = BoxDecoration(
  borderRadius: BorderRadius.circular(12),
  border: Border.all(width: 1, color: Color(0xff29f1fa)),
);

class Button extends StatelessWidget {
  final VoidCallback press;
  final ButtonType type;
  final Widget child;
  final Decoration decoration;

  Button({required this.press, required this.type, required this.child})
      : decoration = type == ButtonType.FULL
            ? _full
            : type == ButtonType.HALF
                ? _half
                : _empty;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: press,
      child: Container(
        decoration: decoration,
        child: child,
      ),
    );
  }
}

class Input extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hint;
  final TextInputType? type;
  final double width;
  final double height;
  final bool tiny;

  Input(
      {required this.onChanged,
      required this.hint,
      this.type,
      this.tiny = false,
      double? width,
      double? height})
      : this.width = width ?? 300.w,
        this.height = height ?? 52.h;

  final _contentStyle = TextStyle(
    color: Colors.white60,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  final _tinyContentStyle = TextStyle(
    color: Colors.white60,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset('assets/input.png', fit: BoxFit.fill),
          ),
          Container(
            width: tiny ? width * .8 : width * .66,
            height: height * .66,
            alignment: Alignment.center,
            child: TextField(
              onChanged: onChanged,
              textAlign: TextAlign.center,
              keyboardType: type,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: tiny ? _tinyContentStyle : _contentStyle,
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(
                    12.w, 0, 12.w, tiny ? height * 0.35.h : height * .25.h),
              ),
              style: tiny ? _tinyContentStyle : _contentStyle,
            ),
          ),
        ],
      ),
    );
  }
}
