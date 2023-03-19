import 'dart:convert';
import 'package:calino/commons/network/service.dart';
import 'package:calino/home/report.dart';
import 'package:dio/dio.dart';

class HomeService {
  HomeService._();

  static final base = 'http://47.108.158.10:8089/';

  static Future<void> uploadPics(List<String> pics, PigFuncType type) async {
    var formData = FormData.fromMap(
        {'files': pics.map((e) => MultipartFile.fromFileSync(e)).toList()});
    var api = type == (PigFuncType.COUNT) ? 'inventory' : 'identify';
    await Network.post(
        'https://calino.com.cn:35280/calino/insurance/report/upload/$api',
        data: formData);
  }

  static Future<void> deletePic(String id) async {
    var map = {'id': id};
    await Network.post(base + 'insurance/report/delete',
        data: json.encode(map));
  }

  static Future<List<Report>> getReport(PigFuncType type) async {
    var api = type == (PigFuncType.COUNT) ? 'inventory' : 'identify';
    var response = await Network.get(base + 'insurance/report/$api');
    return List<Report>.from(
        response.data['data'].map((e) => Report.fromJson(e, type)));
  }

  static Future<void> modifyReport(
      String id, bool isAdd, int index, double x, double y) async {
    var map = {'id': id, 'isAdd': isAdd, 'index': index, 'x': x, 'y': y};
    await Network.post(base + 'insurance/report/modify',
        data: json.encode(map));
  }
}
