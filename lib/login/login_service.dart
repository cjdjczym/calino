import 'dart:convert';
import 'package:calino/commons/network/service.dart';
import 'package:calino/commons/prefs.dart';
import 'package:calino/user/user_service.dart';

class LoginService {
  LoginService._();

  static final base = 'http://47.108.158.10:8089/';

  static Future<void> refreshToken() async {
    var map = {'refreshToken': SpUtil.refreshToken.value};
    var response = await Network.post(base + 'system/auth/refresh-token',
        queryParameters: map);
    SpUtil.accessToken.value = response.data['data']['accessToken'];
    var time = response.data['data']['expiresTime'].toString();
    time = time.replaceAll('.', '-');
    time = time + ':00';
    SpUtil.expiresTime.value = time;
    SpUtil.refreshToken.value = response.data['data']['refreshToken'];
  }

  static Future<void> getLoginCaptcha(String mobile) async {
    await Network.post(
      base + 'app/auth/send-sms-code',
      data: json.encode({'mobile': mobile, 'scene': 1}),
    );
  }

  static Future<void> getRegisterCaptcha(String mobile, bool invite) async {
    await Network.post(
      base + 'app/auth/register/send-sms-code',
      data: json.encode({'mobile': mobile, 'scene': invite ? 4 : 3}),
    );
  }

  static Future<void> pwLogin(String mobile, String password) async {
    var map = {'mobile': mobile, 'password': password};
    var response =
        await Network.post(base + 'app/auth/login', data: json.encode(map));
    SpUtil.accessToken.value = response.data['data']['accessToken'];
    var time = response.data['data']['expiresTime'].toString();
    time = time.replaceAll('.', '-');
    time = time + ':00';
    SpUtil.expiresTime.value = time;
    SpUtil.refreshToken.value = response.data['data']['refreshToken'];
    SpUtil.isLogin.value = true;
    UserService.getUserData();
  }

  static Future<void> codeLogin(String mobile, String code) async {
    var map = {'mobile': mobile, 'code': code};
    var response =
        await Network.post(base + 'app/auth/sms-login', data: json.encode(map));
    SpUtil.accessToken.value = response.data['data']['accessToken'];
    var time = response.data['data']['expiresTime'].toString();
    time = time.replaceAll('.', '-');
    time = time + ':00';
    SpUtil.expiresTime.value = time;
    SpUtil.refreshToken.value = response.data['data']['refreshToken'];
    SpUtil.isLogin.value = true;
    UserService.getUserData();
  }

  static Future<void> register(
      String idCard,
      String mobile,
      String code,
      String password,
      String checkPassword,
      String name,
      String farmName,
      String sequenceCode,
      int qrCodeId) async {
    var map = {
      'idCard': idCard,
      'checkPassword': checkPassword,
      'code': code,
      'farmName': farmName,
      'mobile': mobile,
      'name': name,
      'password': password,
      'qrCodeId': qrCodeId,
      'sequenceCode': sequenceCode,
    };
    await Network.post(base + 'insurance/user/register',
        data: json.encode(map));
    await pwLogin(mobile, password);
  }

  static Future<void> acceptInvitation(
    String idCard,
    String checkPassword,
    String code,
    String mobile,
    String name,
    String password,
  ) async {
    var map = {
      'idCard': idCard,
      'checkPassword': checkPassword,
      'code': code,
      'mobile': mobile,
      'name': name,
      'password': password,
    };
    await Network.post(base + 'app/user/accept/invitation',
        queryParameters: map);
    await pwLogin(mobile, password);
  }
}
