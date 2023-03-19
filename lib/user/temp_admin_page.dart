import 'package:calino/commons/prefs.dart';
import 'package:calino/commons/route.dart';
import 'package:calino/commons/template.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/user/model.dart';
import 'package:calino/user/pop_window.dart';
import 'package:calino/user/user_center_page.dart';
import 'package:calino/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'invite_page.dart';

var joinMemberInfo = [];
var applyMemberInfo = [];
var currentFarmId;

/// 子账号管理页
class TeamAdminScreen extends StatefulWidget {
  @override
  State<TeamAdminScreen> createState() => _TeamAdminScreenState();
}

class _TeamAdminScreenState extends State<TeamAdminScreen> {
  String _avatarUrl = '';
  String _farmName = '';
  bool openEdit = false;

  void _changeEditState(bool newValue) {
    setState(() {
      openEdit = !openEdit;
    });
  }

  changeRemark(String value) async {
    await _getMembers();
    setState(() {});
  }

  _getMembers() async {
    var userData = UserData.fromRawJson(SpUtil.userData.value);
    _avatarUrl = userData.userInfo.avatarUrl;
    currentFarmId = userData.createFarm[0].createFarmId;
    var members = await UserService.getMembers(currentFarmId);
    _farmName = members.name;
    joinMemberInfo = members.joined;
    applyMemberInfo = members.applying;
  }

  @override
  Widget build(BuildContext context) {
    return Temp(
      title: '可利农AI猪场',
      hasBack: true,
      hasButton: false,
      content: FutureBuilder(
        future: _getMembers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: <Widget>[
              /// 头部信息栏
              Center(
                child: Container(
                  width: 341.w,
                  height: 110.h,
                  margin: EdgeInsets.only(top: 25.h),
                  child: RoughInfo(
                      avatarUrl: _avatarUrl,
                      username: _farmName,
                      needEdit: false),
                ),
              ),

              /// 已加入子账号
              Center(
                child: Container(
                  width: 342.w,
                  child: JoinedMemberBox(
                    openEdit: openEdit,
                    onChanged: _changeEditState,
                  ),
                ),
              ),
              // 未加入成员
              // Center(
              //   child: Container(
              //     width: 342.w,
              //     child: WaitingMemberBox(),
              //   ),
              // ),
              /// 邀请子账号按钮
              Container(
                  height: 40.h,
                  margin: EdgeInsets.only(top: 33.h),
                  alignment: Alignment.center,
                  child: Container(
                    height: 40.h,
                    width: 315.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: const LinearGradient(
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                          colors: [
                            Color.fromRGBO(8, 185, 193, 1),
                            Color.fromRGBO(7, 89, 184, 1)
                          ]),
                    ),
                    child: TextButton(
                        child: const Text(
                          '邀请子账号',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                        onPressed: () => Ex.push(context, InviteScreen())),
                  )),
            ],
          );
        },
      ),
    );
  }
}

/// 盒子标题
class TitleBox extends StatefulWidget {
  TitleBox(
      {required this.title,
      required this.data,
      this.needEdit = false,
      required this.editTitle,
      required this.onChanged,
      Key? key})
      : super(key: key);
  final String title;
  final int data;
  final bool needEdit;
  final String editTitle;
  final ValueChanged<bool> onChanged;

  @override
  State<TitleBox> createState() => _TitleBoxState(
      title: title,
      data: data,
      needEdit: needEdit,
      editTitle: editTitle,
      onChanged: onChanged);
}

class _TitleBoxState extends State<TitleBox> {
  _TitleBoxState(
      {required this.title,
      required this.data,
      required this.needEdit,
      required this.editTitle,
      required this.onChanged});

  String title;
  int data;
  bool needEdit = false;
  String editTitle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      height: 50.h,
      child: Stack(
        children: [
          Positioned(
            left: 20.w,
            top: 20.h,
            child: Text(
              '$title $data 人',
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.9),
                fontSize: 14,
              ),
            ),
          ),
          Positioned(
            top: 13.h,
            right: 14.w,
            child: needEdit
                ? Container(
                    height: 34.h,
                    width: 72.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                          colors: [
                            Color.fromRGBO(8, 185, 193, 1),
                            Color.fromRGBO(7, 89, 184, 1)
                          ]),
                    ),
                    child: TextButton(
                        child: Center(
                          child: Text(
                            editTitle,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 9.9),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            onChanged(true);
                          });
                        }),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

/// 信息盒子
class MemberInfoBox extends StatefulWidget {
  MemberInfoBox(
      {required this.id,
      required this.avatarUrl,
      required this.name,
      required this.remark,
      required this.isEnd,
      required this.hasJoined,
      required this.openEdit,
      Key? key})
      : super(key: key);
  final id;
  final avatarUrl;
  final name;
  final remark;
  final bool hasJoined;
  final bool isEnd;
  final bool openEdit;

  @override
  State<MemberInfoBox> createState() => _MemberInfoBoxState(
      id: id,
      avatarUrl: avatarUrl,
      name: name,
      remark: remark,
      isEnd: isEnd,
      hasJoined: hasJoined,
      openEdit: openEdit);
}

class _MemberInfoBoxState extends State<MemberInfoBox> {
  _MemberInfoBoxState(
      {required this.id,
      required this.avatarUrl,
      required this.name,
      required this.remark,
      required this.isEnd,
      required this.hasJoined,
      required this.openEdit});

  var id;
  var avatarUrl;
  var name;
  var remark;
  bool hasJoined;
  bool openEdit;
  bool isEnd = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325.w,
      height: 70.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment(-1, 0),
            end: Alignment(1, 0),
            colors: [
              Color.fromRGBO(8, 131, 255, 0),
              Color.fromRGBO(36, 212, 227, 0.5)
            ]),
        border: Border(
            top: BorderSide(color: Color.fromRGBO(19, 175, 216, 1), width: 1),
            right: BorderSide(color: Color.fromRGBO(19, 175, 216, 1), width: 1),
            bottom: BorderSide(
                color: Color.fromRGBO(19, 175, 216, 1), width: (isEnd ? 1 : 0)),
            left: BorderSide(color: Color.fromRGBO(19, 175, 216, 1), width: 1)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15.h,
            child: Row(
              children: [
                // 头像
                Container(
                  margin: EdgeInsets.only(left: 15.w),
                  width: 39.w,
                  height: 39.h,
                  child: ClipOval(
                    child: avatarUrl == null || avatarUrl.isEmpty
                        ? Image.asset('assets/user/tempAva.png',
                            fit: BoxFit.fill)
                        : Image.network(avatarUrl, fit: BoxFit.fill),
                  ),
                ),
                // 姓名
                Container(
                  margin: EdgeInsets.only(left: 12.w),
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 18.w,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                // 备注
                Container(
                  margin: EdgeInsets.only(left: 12.w),
                  child: Text(
                    remark == '' ? '' : '($remark)',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                        fontSize: 14.w,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          // 忽略
          Positioned(
              top: 10.h,
              right: 67.w,
              child: !hasJoined
                  ? TextButton(
                      onPressed: () {
                        // ignoreApply(id: id, farmId: currentFarmId);
                      },
                      child: Text(
                        '忽略',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 13.w),
                      ),
                    )
                  : (openEdit
                      ? TextButton(
                          onPressed: () async {
                            await UserService.deleteMember(id, currentFarmId);
                            Toast.show('删除成功');
                            Ex.pushReplacement(context, TeamAdminScreen());
                          },
                          child: Text(
                            '删除',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 13.w),
                          ),
                        )
                      : Container())),
          // 确认加入团队
          Positioned(
              top: 20.h,
              right: 8.w,
              child: !hasJoined
                  ? Container(
                      height: 28.h,
                      width: 68.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                            begin: Alignment(0, -1),
                            end: Alignment(0, 1),
                            colors: [
                              Color.fromRGBO(8, 185, 193, 1),
                              Color.fromRGBO(7, 89, 184, 1)
                            ]),
                      ),
                      child: TextButton(
                          child: Center(
                            child: Text(
                              '加入团队',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 10.w),
                            ),
                          ),
                          onPressed: () {
                            // agreeApply(id: id, farmId: currentFarmId);
                          }),
                    )
                  : (openEdit
                      ? Container(
                          height: 32.h,
                          width: 68.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 1),
                                colors: [
                                  Color.fromRGBO(8, 185, 193, 1),
                                  Color.fromRGBO(7, 89, 184, 1)
                                ]),
                          ),
                          child: TextButton(
                              child: Center(
                                child: Text(
                                  '修改备注',
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 8.w),
                                ),
                              ),
                              onPressed: () async {
                                openModifyRemark(
                                    context: context,
                                    headline: '修改备注',
                                    userId: id,
                                    farmId: currentFarmId);
                              }),
                        )
                      : Container()))
        ],
      ),
    );
  }
}

/// 已加入团队成员
class JoinedMemberBox extends StatefulWidget {
  JoinedMemberBox({required this.openEdit, required this.onChanged, Key? key})
      : super(key: key);
  final bool openEdit;
  final ValueChanged<bool> onChanged;

  @override
  State<JoinedMemberBox> createState() =>
      _JoinedMemberBoxState(openEdit: openEdit, onChanged: onChanged);
}

class _JoinedMemberBoxState extends State<JoinedMemberBox> {
  _JoinedMemberBoxState({required this.openEdit, required this.onChanged});

  bool openEdit;
  final ValueChanged<bool> onChanged;

  List<Widget> _updateJoinMembers() {
    List<Widget> joinMembers = [];
    joinMembers.add(TitleBox(
        title: '子账号',
        data: joinMemberInfo.length,
        needEdit: true,
        editTitle: '编辑子账号',
        onChanged: onChanged));
    for (int i = 0; i < joinMemberInfo.length; i++) {
      var element = joinMemberInfo[i];
      joinMembers.add(MemberInfoBox(
        id: element.id,
        avatarUrl: element.imgSrc,
        name: element.name,
        remark: element.remarks,
        isEnd: (i == joinMemberInfo.length - 1) ? true : false,
        hasJoined: true,
        openEdit: openEdit,
      ));
    }
    return joinMembers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _updateJoinMembers());
  }
}

/// 等待审核的团队成员
class WaitingMemberBox extends StatefulWidget {
  const WaitingMemberBox({Key? key}) : super(key: key);

  @override
  State<WaitingMemberBox> createState() => _WaitingMemberBoxState();
}

class _WaitingMemberBoxState extends State<WaitingMemberBox> {
  List<Widget> waitMembers = [];

  @override
  void initState() {
    super.initState();
    waitMembers.add(TitleBox(
      title: '待通过',
      data: applyMemberInfo.length,
      needEdit: false,
      editTitle: '',
      onChanged: (bool newValue) {},
    ));
    for (int i = 0; i < applyMemberInfo.length; i++) {
      var element = applyMemberInfo[i];
      waitMembers.add(MemberInfoBox(
        id: element.id,
        avatarUrl: element.imgSrc,
        name: element.username,
        remark: element.remarks,
        isEnd: (i == joinMemberInfo.length - 1) ? true : false,
        hasJoined: false,
        openEdit: false,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: waitMembers);
  }
}
