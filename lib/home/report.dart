import 'dart:convert';

import 'package:calino/commons/prefs.dart';
import 'package:flutter/material.dart' show Offset;

String formatDate(DateTime date) => date.toString().split('.')[0];

enum PigFuncType {
  COUNT('猪只数目盘点', '智能盘点报告'),
  IDENTIFY('猪只唯一化识别', '猪只身份识别报告');

  const PigFuncType(this.picTitle, this.detailTitle);

  final String picTitle;
  final String detailTitle;
}

class Report {
  final String id;
  final String createAt; // 上传时间
  final bool sub; // 是否为子账户
  final String name; // 账号名称
  bool running; // 是否正在分析中
  final PigFuncType type;
  List<SingleCount> countList;
  List<SingleIdentify> identifyList;

  Report(this.id, this.createAt, this.sub, this.name, this.running, this.type,
      this.countList, this.identifyList);

  Report.fromJson(Map<String, dynamic> json, PigFuncType type)
      : id = json['id'].toString(),
        sub = json['isSub'] ?? false,
        name = json['name'] ?? '',
        createAt = json['createAt'] ?? '',
        running = json['running'] ?? true,
        this.type = type,
        identifyList = (type == PigFuncType.IDENTIFY)
            ? List<SingleIdentify>.from(
                json['details'].map((e) => SingleIdentify.fromJson(e)))
            : [],
        countList = (type == PigFuncType.COUNT)
            ? List<SingleCount>.from(
                json['details'].map((e) => SingleCount.fromJson(e)))
            : [];

  String get day => createAt.split(' ')[0];
}

class SingleIdentify {
  final String id;
  final String no; // 耳标号
  final String time; // 采集时间
  final String hint; // 情况说明，为空时代表正常
  final String url; // 上传的照片url

  SingleIdentify(this.id, this.no, this.time, this.hint, this.url);

  SingleIdentify.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        no = json['no'] ?? '',
        time = json['time'] ?? '',
        hint = json['hint'] ?? '',
        url = json['url'] ?? '';
}

class SingleCount {
  final String id;
  int count; // 图片中猪的数量
  List<Offset> posList; // 每只猪的位置
  final String url; // 上传的照片url
  List<CountModify> modifyList; // 修改记录

  SingleCount(this.id, this.count, this.posList, this.url)
      : this.modifyList = [];

  SingleCount.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        count = json['count'] ?? 0,
        posList =
            List<Offset>.from(json['positions'].map((e) => _parseOffset(e))),
        url = json['url'] ?? '',
        modifyList = List<CountModify>.from(
            json['modifications'].map((e) => CountModify.fromJson(e)));
}

class CountModify {
  final String updateAt; // 修改时间
  final String name; // 修改账号
  final bool sub; // 是否为子账户
  final Offset pos; // 该猪的位置
  final int index; // 修改的猪只序号
  final bool isAdd; // 添加还是删除
  final String hint; // 修改内容

  CountModify(
      this.updateAt, this.name, this.sub, this.pos, int index, bool isAdd,
      [String? hint])
      : this.index = index,
        this.isAdd = isAdd,
        this.hint = hint ??
            (isAdd
                ? '添加识别序号为${index + 1}的猪只，此图中猪只数目增加1'
                : '删除识别序号为${index + 1}的猪只，此图中猪只数目减少1');

  CountModify.fromJson(Map<String, dynamic> json)
      : updateAt = json['updateAt'] ?? '',
        name = json['name'] ?? '',
        sub = json['isSub'] ?? false,
        pos = _parseOffset(json),
        index = int.parse(json['index']),
        isAdd = json['isAdd'],
        hint = json['hint'] ??
            (json['isAdd']
                ? '添加识别序号为${int.parse(json['index']) + 1}的猪只，此图中猪只数目增加1'
                : '删除识别序号为${int.parse(json['index']) + 1}的猪只，此图中猪只数目减少1');
}

Offset _parseOffset(dynamic json) =>
    Offset(double.parse(json['x'] ?? '0.0'), double.parse(json['y'] ?? '0.0'));

class IdentifyPicBean {
  final List<IdentifyPic> list;

  IdentifyPicBean() : list = [];

  IdentifyPicBean.fromJson(Map<String, dynamic> map)
      : list = []
          ..addAll((map['list'] as List).map((e) => IdentifyPic.fromJson(e)));

  Map<String, dynamic> toJson() => {
        'list': list.map((e) => e.toJson()).toList(),
      };
}

class IdentifyPic {
  final List<String> front;
  final List<String> left;
  final List<String> right;

  IdentifyPic()
      : this.front = [],
        this.left = [],
        this.right = [];

  IdentifyPic.fromJson(Map<String, dynamic> map)
      : front = []..addAll((map['front'] as List).map((e) => '$e')),
        left = []..addAll((map['left'] as List).map((e) => '$e')),
        right = []..addAll((map['right'] as List).map((e) => '$e'));

  Map<String, dynamic> toJson() => {
        'front': front,
        'left': left,
        'right': right,
      };

  int get count => front.length + left.length + right.length;
}

/// 工具类
class Identify {
  Identify._();

  static IdentifyPicBean get _bean {
    if (SpUtil.identityPics.value == '') return IdentifyPicBean();
    return IdentifyPicBean.fromJson(json.decode(SpUtil.identityPics.value));
  }

  static bool get allFinish => _bean.list.every((e) => e.count == 9);

  static void clearUnfinished() => _bean.list.removeWhere((e) => e.count != 9);

  static List<String> get pics {
    var rst = <String>[];
    _bean.list.forEach((e) {
      rst.addAll(e.front);
      rst.addAll(e.left);
      rst.addAll(e.right);
    });
    return rst;
  }

  static int get identifyType {
    for (var e in _bean.list) {
      if (e.front.length != 3) return 0;
      if (e.left.length != 3) return 1;
      if (e.right.length != 3) return 2;
    }
    return 0;
  }

  static int get identifyIndex {
    for (var e in _bean.list) {
      if (e.front.length != 3) return e.front.length;
      if (e.left.length != 3) return e.left.length;
      if (e.right.length != 3) return e.right.length;
    }
    return 0;
  }

  static int addPic(String path) {
    var bean = _bean;
    for (int i = 0; i < bean.list.length; i++) {
      var e = bean.list[i];
      if (e.count != 9) {
        if (e.front.length != 3)
          e.front.add(path);
        else if (e.left.length != 3)
          e.left.add(path);
        else
          e.right.add(path);
        SpUtil.identityPics.value = json.encode(bean.toJson());
        return e.count == 9 ? i : -1;
      }
    }
    bean.list.add(IdentifyPic()..front.add(path));
    SpUtil.identityPics.value = json.encode(bean.toJson());
    return -1;
  }

  static void delPic(String path) {
    var bean = _bean;
    for (var e in bean.list) {
      if (e.front.contains(path)) {
        e.front.remove(path);
      } else if (e.left.contains(path)) {
        e.left.remove(path);
      } else if (e.right.contains(path)) {
        e.right.remove(path);
      } else {
        continue;
      }
      break;
    }
    SpUtil.identityPics.value = json.encode(bean.toJson());
  }
}
