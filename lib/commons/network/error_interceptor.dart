import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioError e, handler) async {
    if (e is MyDioError) return handler.reject(e);
    if (e.type == DioErrorType.connectTimeout)
      e.error = "网络连接超时";
    else if (e.type == DioErrorType.sendTimeout)
      e.error = "发送请求超时";
    else if (e.type == DioErrorType.receiveTimeout)
      e.error = "响应超时";

    else if (!kDebugMode) e.error = "发生未知错误";

    return handler.reject(e);
  }
}

class MyDioError extends DioError {
  @override
  final String error;

  MyDioError({required this.error, String path = 'unknown'})
      : super(requestOptions: RequestOptions(path: path));
}
