import 'package:calino/commons/network/auth_interceptor.dart';
import 'package:calino/commons/network/response_interceptor.dart';
import 'package:dio/dio.dart';
import 'error_interceptor.dart';

class Network {
  static Network? _instance;

  static Network get instance {
    _instance ??= Network._internal();
    return _instance!;
  }

  Dio dio;

  Network._internal()
      : dio = Dio()
          ..options = BaseOptions(
              connectTimeout: 30000,
              sendTimeout: 1000 * 60 * 2,
              receiveTimeout: 1000 * 60 * 2,
              responseType: ResponseType.json)
          ..interceptors.add(ErrorInterceptor())
          ..interceptors.add(ResponseInterceptor())
          ..interceptors.add(AuthInterceptor())
          ..interceptors
              .add(LogInterceptor(responseBody: true, requestBody: true));

  static Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) {
    return Network.instance.dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  static Future<Response<dynamic>> post(String path,
      {Map<String, dynamic>? queryParameters,
      ProgressCallback? onSendProgress,
      Options? options,
      data}) {
    return Network.instance.dio.post(
      path,
      queryParameters: queryParameters,
      data: data,
      onSendProgress: onSendProgress,
      options: options,
    );
  }

  static Future<Response<dynamic>> put(String path,
      {Map<String, dynamic>? queryParameters,
      ProgressCallback? onSendProgress,
      data}) {
    return Network.instance.dio.put(
      path,
      queryParameters: queryParameters,
      data: data,
      onSendProgress: onSendProgress,
    );
  }
}
