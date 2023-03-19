import 'package:calino/commons/network/error_interceptor.dart';
import 'package:calino/commons/prefs.dart';
import 'package:calino/commons/route.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/login/login_page.dart';
import 'package:calino/login/login_service.dart';
import 'package:calino/main.dart';
import 'package:dio/dio.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    var code = response.data['code'] ?? -1;
    var error = '';
    switch (code) {
      case 200:
        break; // pass
      case 401:
        var time = DateTime.parse(SpUtil.expiresTime.value);
        if (time.isAfter(DateTime.now())) {
          await LoginService.refreshToken();
          error = '请重新尝试';
        } else {
          Ex.pushAndRemoveUntil(
              MyApp.navigatorState.currentContext!, LoginPage());
          error = '登录失效，请重新登录';
        }
        break;
      default:
        error = response.data['msg'];
    }
    if (error == '') {
      return handler.next(response);
    } else {
      Toast.show(error);
      return handler.reject(MyDioError(error: error));
    }
  }
}
