import 'package:calino/commons/prefs.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["Authorization"] = 'Bearer ' + SpUtil.accessToken.value;
    return handler.next(options);
  }
}