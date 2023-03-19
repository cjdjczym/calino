import 'dart:convert';

import 'package:calino/commons/network/service.dart';
import 'package:calino/commons/prefs.dart';
import 'package:calino/user/model.dart';

class UserService {
  UserService._();

  static final base = 'http://47.108.158.10:8089/';

  static Future<void> logout() async {
    await Network.post(base + 'system/auth/logout');
    SpUtil.logout();
  }

  static Future<void> getUserData() async {
    var response = await Network.get(base + 'app/user/info');
    var userData = UserData.fromJson(response.data['data']);
    SpUtil.userData.value = userData.toRawJson();
  }

  static Future<MemberData> getMembers(int farmId) async {
    var response = await Network.get(base + 'app/user/members/info',
        queryParameters: {'farmId': farmId});
    return MemberData.fromJson(response.data['data']);
  }

  static Future<void> deleteMember(int id, int farmId) async {
    var map = {
      'id': id,
      'farmId': farmId,
      'option': 'delete',
    };
    await Network.post(base + 'app/user/members/edit', data: json.encode(map));
  }

  static Future<void> modifyRemarkMember(
      int id, int farmId, String newRemark) async {
    var map = {
      'id': id,
      'farmId': farmId,
      'newRemarks': newRemark,
      'option': 'remake',
    };
    await Network.post(base + 'app/user/members/edit', data: json.encode(map));
  }

  static Future<String> getTBCode() async {
    var map = {'key': 'calino'};
    var response =
        await Network.get(base + 'app/user/get/tb/pwd', queryParameters: map);
    return response.data['data'];
  }

  static Future<void> modifyName(String name) async {
    var map = {'name': name};
    await Network.post(base + 'app/user/modify/info', queryParameters: map);
  }

  static Future<int> checkQrCode(String sequenceCode) async {
    var map = {'sequenceCode': sequenceCode};
    var response = await Network.post(base + 'app/verify/sequence-code',
        data: json.encode(map));
    return response.data['data'];
  }

  static Future<void> inviteMember(String mobile) async {
    var map = {'mobile': mobile};
    await Network.post(base + 'app/user/invitation', queryParameters: map);
  }

  static Future<void> modifyPassword(
      String oldPassword, String password, String checkPassword) async {
    var map = {
      'oldPassword': oldPassword,
      'newPassword': password,
      'checkPassword': checkPassword,
    };
    await Network.post(base + 'app/user/modify/passwd', queryParameters: map);
  }
}
