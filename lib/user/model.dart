import 'dart:convert';

class UserData {
  final int id;
  final UserInfo userInfo;
  final List<CreateFarm> createFarm;
  final List<JoinFarm> joinFarm;
  final Manager manager;

  factory UserData.fromRawJson(String str) =>
      UserData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  UserData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userInfo = UserInfo.fromJson(json['userInfo']),
        createFarm = (json['createFarm'] == null)
            ? []
            : List<CreateFarm>.from(
                json['createFarm'].map((e) => CreateFarm.fromJson(e))),
        joinFarm = (json['joinFarm'] == null)
            ? []
            : List<JoinFarm>.from(
                json['joinFarm'].map((e) => JoinFarm.fromJson(e))),
        manager = (json['manager'] == null)
            ? Manager.empty()
            : Manager.fromJson(json['manager']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'userInfo': userInfo.toJson(),
        'createFarm': createFarm.map((e) => e.toJson()).toList(),
        'joinFarm': joinFarm.map((e) => e.toJson()).toList(),
        'manager': manager.toJson(),
      };
}

class UserInfo {
  final int id;
  final String nickname;
  final String avatarUrl;
  final String gender;
  final String mobile;
  final String expireTime;

  UserInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nickname = json['nickname'] ?? '',
        avatarUrl = json['avatarUrl'] ?? '',
        gender = json['gender'] ?? '',
        mobile = json['mobile'] ?? '',
        expireTime = json['expireTime'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'avatarUrl': avatarUrl,
        'gender': gender,
        'mobile': mobile,
        'expireTime': expireTime,
      };
}

class CreateFarm {
  final int createFarmId;
  final String createFarmName;

  CreateFarm.fromJson(Map<String, dynamic> json)
      : createFarmId = json['createFarmId'],
        createFarmName = json['createFarmName'] ?? '';

  Map<String, dynamic> toJson() => {
        'createFarmId': createFarmId,
        'createFarmName': createFarmName,
      };
}

class JoinFarm {
  final int joinFarmId;
  final String joinFarmName;

  JoinFarm.fromJson(Map<String, dynamic> json)
      : joinFarmId = json['joinFarmId'],
        joinFarmName = json['joinFarmName'] ?? '';

  Map<String, dynamic> toJson() => {
        'joinFarmId': joinFarmId,
        'joinFarmName': joinFarmName,
      };
}

class Manager {
  final String managerName;
  final String managerMobile;

  Manager.empty()
      : managerName = '',
        managerMobile = '';

  Manager.fromJson(Map<String, dynamic> json)
      : managerName = json['managerName'] ?? '',
        managerMobile = json['managerMobile'] ?? '';

  Map<String, dynamic> toJson() => {
        'managerName': managerName,
        'managerMobile': managerMobile,
      };
}

class MemberData {
  final List<Member> joined;
  final List<Member> applying;
  final String name;

  MemberData.fromJson(Map<String, dynamic> json)
      : joined =
            List<Member>.from(json['joined'].map((e) => Member.fromJson(e))),
        applying =
            List<Member>.from(json['applying'].map((e) => Member.fromJson(e))),
        name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'joined': joined.map((e) => e.toJson()).toList(),
        'applying': applying.map((e) => e.toJson()).toList(),
        'name': name,
      };
}

class Member {
  final int id;
  final String name;
  final String remarks;
  final String imgSrc;

  Member.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? '',
        remarks = json['remarks'] ?? '',
        imgSrc = json['imgSrc'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'remarks': remarks,
        'imgSrc': imgSrc,
      };
}
