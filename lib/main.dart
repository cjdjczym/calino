import 'package:calino/home/home_page.dart';
import 'package:calino/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'commons/prefs.dart';
import 'commons/toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SpUtil.init();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorState = GlobalKey();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Toast.init(MyApp.navigatorState.currentContext!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '可利农',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      navigatorKey: MyApp.navigatorState,
      home: SpUtil.isLogin.value ? HomePage() : LoginPage(),
      builder: (context, child) {
        ScreenUtil.init(context, designSize: const Size(375, 812));
        return Overlay(
          initialEntries: [
            if (child != null) ...[
              OverlayEntry(
                builder: (context) => GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                  child: child,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
