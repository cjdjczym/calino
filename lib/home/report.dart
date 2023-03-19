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
            List<Offset>.from(json['positions'].map((e) => parseOffset(e))),
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
        pos = parseOffset(json),
        index = int.parse(json['index']),
        isAdd = json['isAdd'],
        hint = json['hint'] ??
            (json['isAdd']
                ? '添加识别序号为${int.parse(json['index']) + 1}的猪只，此图中猪只数目增加1'
                : '删除识别序号为${int.parse(json['index']) + 1}的猪只，此图中猪只数目减少1');
}

Offset parseOffset(dynamic json) =>
    Offset(double.parse(json['x'] ?? '0.0'), double.parse(json['y'] ?? '0.0'));
