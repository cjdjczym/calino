import 'package:calino/commons/prefs.dart';
import 'package:calino/commons/route.dart';
import 'package:calino/commons/toast.dart';
import 'package:calino/login/login_page.dart';
import 'package:calino/user/model.dart';
import 'package:calino/user/modify_password_page.dart';
import 'package:calino/user/pop_window.dart';
import 'package:calino/user/temp_admin_page.dart';
import 'package:calino/user/user_service.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

String tbCode = '';

/// 个人信息页
class UserCenterScreen extends StatefulWidget {
  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen> {
  String _username = '';
  String _mobile = '';
  String _avatarUrl = '';
  String _expireTime = '';
  String _adminName = '';
  String _adminMobile = '';
  String _farmName = '';
  bool _isAdmin = false;

  _getInitInfo() async {
    await _getUserInfo();
    tbCode = await UserService.getTBCode();
  }

  _getUserInfo() async {
    var userData = UserData.fromRawJson(SpUtil.userData.value);
    _username = userData.userInfo.nickname;
    _mobile = userData.userInfo.mobile;
    _avatarUrl = userData.userInfo.avatarUrl;
    _expireTime = userData.userInfo.expireTime;
    _adminMobile = userData.manager.managerMobile;
    _adminName = userData.manager.managerName;
    if (userData.joinFarm.isNotEmpty) {
      _farmName = userData.joinFarm[0].joinFarmName;
    }
    _isAdmin = (userData.createFarm.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getInitInfo(),
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
                      username: _username,
                      needEdit: true),
                ),
              ),

              /// 团队管理
              Center(
                child: _isAdmin
                    ? Container(
                    margin: EdgeInsets.fromLTRB(24.w, 19.h, 24.w, 0),
                    child: Center(
                      child: NavigatorBox(
                        title: '子账号管理',
                        onPressed: () {
                          Ex.push(context, TeamAdminScreen());
                        },
                      ),
                    ))
                    : Container(
                    margin: EdgeInsets.fromLTRB(32.w, 19.h, 32.w, 0),
                    child: Center(
                      child: TeamInfo(
                        adminName: _adminName,
                        adminMobile: _adminMobile,
                        farmName: _farmName,
                      ),
                    )),
              ),

              /// 基本信息
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0),
                  child: BasicInfo(
                      mobile: _mobile,
                      expireTime: _expireTime,
                      isAdmin: _isAdmin),
                ),
              ),

              /// 可利农公众号二维码
              Center(
                child: TwoDimensionalCodeBox(
                  flag: 0,
                  imgUrl: 'assets/user/userCenter/calinoWechat.png',
                  height: 255.h,
                ),
              ),

              /// 修改密码按钮
              Container(
                  height: 40.w,
                  child: Center(
                    child: Container(
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
                            '修改密码',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1)),
                          ),
                          onPressed: () {
                            Ex.push(context, ModifyPasswordScreen());
                          }),
                    ),
                  )),

              /// 退出按钮
              Container(
                  height: 40.w,
                  margin: EdgeInsets.only(top: 20.h),
                  child: Center(
                    child: Container(
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
                          child: Text(
                            '退出当前账号',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1)),
                          ),
                          onPressed: () async {
                            await UserService.logout();
                            Toast.show('账号退出成功');
                            Ex.pushAndRemoveUntil(context, LoginPage());
                          }),
                    ),
                  )),
            ],
          );
        });
  }
}

/// 头像姓名部分
class RoughInfo extends StatefulWidget {
  RoughInfo(
      {required this.avatarUrl,
      required this.username,
      required this.needEdit,
      Key? key})
      : super(key: key);
  final String avatarUrl;
  final String username;
  final bool needEdit;

  @override
  State<RoughInfo> createState() => _RoughInfoState(
      avatarUrl: avatarUrl, username: username, needEdit: needEdit);
}

class _RoughInfoState extends State<RoughInfo> {
  _RoughInfoState(
      {required this.avatarUrl,
      required this.username,
      required this.needEdit});

  String avatarUrl = '';
  String username = '';
  bool needEdit = false;

  changeName(String newName) {
    username = newName;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          /// 头像
          Positioned(
              child: Container(
                  width: 110.w,
                  height: 110.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/user/userCenter/avatarBackground.png'),
                          fit: BoxFit.contain)),
                  child: Center(
                    child: Container(
                        width: 70.w,
                        height: 70.h,
                        child: ClipOval(
                          child: avatarUrl == ''
                              ? Image.asset('assets/user/tempAva.png',
                                  fit: BoxFit.contain)
                              : Image.network(avatarUrl, fit: BoxFit.contain),
                        )),
                  ))),

          /// 名字
          Positioned(
              top: 22.h,
              left: 83.w,
              child: Container(
                width: 241.w,
                height: 65.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/user/userCenter/nameBackground.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: needEdit ? 36.w : 0.w),
                      child: Center(
                        child: Container(
                          width: 150.w,
                          child: Center(
                            child: Text(
                              username,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 24.w),
                            ),
                          ),
                        ),
                      ),
                    ),
                    needEdit
                        ? Positioned(
                            right: 28.w,
                            top: 22.h,
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/user/userCenter/editName.png'),
                                      fit: BoxFit.contain)),
                              child: TextButton(
                                onPressed: () {
                                  openModifyName(
                                      context: context,
                                      headline: '修改昵称',
                                      onChange: changeName);
                                },
                                child: Text(''),
                              ),
                            ))
                        : Container(),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

/// 大标题
class TitleBox extends StatelessWidget {
  TitleBox({required this.title, Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      height: 48.h,
      child: Stack(
        children: [
          Positioned(
            left: 20.w,
            top: 10.h,
            child: Text(
              title,
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// 跳转导航盒子
class NavigatorBox extends StatelessWidget {
  NavigatorBox({required this.title, required this.onPressed, Key? key})
      : super(key: key);
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          width: 343.w,
          height: 48.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment(-1, 0),
                end: Alignment(1, 0),
                colors: [
                  Color.fromRGBO(8, 131, 255, 0),
                  Color.fromRGBO(36, 212, 227, 0.5)
                ]),
            border: Border.all(
              color: Color.fromRGBO(19, 175, 216, 1),
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 20.w,
                top: 10.h,
                child: Text(
                  title,
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Positioned(
                top: 15.h,
                right: 10.w,
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 16.w,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// 可展开盒子
class ExpandBox extends StatelessWidget {
  ExpandBox({this.title = '', Map<String, dynamic>? infoMap, this.isEnd = true})
      : this.infoMap = infoMap ?? {};
  final String title;
  final Map<String, dynamic> infoMap;
  final bool isEnd;

  @override
  Widget build(BuildContext context) {
    /// 展开详细
    var expandDetails = <Widget>[];
    infoMap.forEach((key, value) {
      expandDetails.add(ExpandDetail(name: key, content: value));
    });
    return Container(
        width: 343.w,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment(-1, 0),
              end: Alignment(1, 0),
              colors: [
                Color.fromRGBO(8, 131, 255, 0),
                Color.fromRGBO(36, 212, 227, 0.4)
              ]),
          border: Border(
              top: BorderSide(color: Color.fromRGBO(19, 175, 216, 1), width: 1),
              right:
                  BorderSide(color: Color.fromRGBO(19, 175, 216, 1), width: 1),
              bottom: BorderSide(
                  color: Color.fromRGBO(19, 175, 216, 1),
                  width: (isEnd ? 1 : 0.1)),
              left:
                  BorderSide(color: Color.fromRGBO(19, 175, 216, 1), width: 1)),
        ),
        child: ExpandablePanel(
          header: Container(
            width: 343.w,
            height: 48.h,
            child: Align(
              alignment: Alignment(-0.8, 0),
              child: Text(
                title,
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 16.w,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          collapsed: Container(),
          expanded: Column(children: expandDetails),
          theme:
              ExpandableThemeData(iconColor: Color.fromRGBO(255, 255, 255, 1)),
        ));
  }
}

/// 展开盒子详细项
class ExpandDetail extends StatelessWidget {
  ExpandDetail({required String name, required this.content, Key? key})
      : this.name = name,
        this.index = (name == '官方网店')
            ? 0
            : (name == '公众号')
                ? 1
                : -1;
  final name; // 标题名称
  final content; // 内容
  final index;

  @override
  Widget build(BuildContext context) {
    // 特殊情况
    Map<String, Widget> extra = {
      // 官方网店，点击复制
      '官方网店': TextButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: tbCode));
          Toast.show('已将淘宝口令粘贴至剪切板');
        },
        child: Container(
          width: 343.w,
          height: 70.h,
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Color.fromRGBO(19, 175, 216, 1), width: 0), // 上边边框
                right: BorderSide(
                    color: Color.fromRGBO(19, 175, 216, 1), width: 0), // 右侧边框
                bottom: BorderSide(
                    color: Color.fromRGBO(19, 175, 216, 1), width: 0), // 底部边框
                left: BorderSide(
                    color: Color.fromRGBO(19, 175, 216, 1), width: 0)), // 左侧边框
          ),
          child: Stack(
            children: [
              Positioned(
                left: 20.w,
                top: 14.h,
                child: Text(
                  '官方网店 : 可利农CALINO',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 14.w,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Positioned(
                left: 20.w,
                top: 40.h,
                child: Text(
                  '点击此处复制商家淘口令，打开淘宝APP后即可自动跳转',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 10.w,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    };
    return (extra.containsKey(name))
        ? extra[name]!
        : Container(
            width: 343.w,
            height: 48.h,
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Color.fromRGBO(19, 175, 216, 1), width: 0),
                  // 上边边框
                  right: BorderSide(color: Colors.red, width: 0),
                  // 右侧边框
                  bottom: BorderSide(color: Colors.yellow, width: 0),
                  // 底部边框
                  left: BorderSide(color: Colors.cyan, width: 0)), // 左侧边框
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 20.w,
                  top: 14.h,
                  child: Text(
                    '$name${name != '' ? ' :  ' : ''}$content',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 13.w,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          );
  }
}

/// 团队信息
class TeamInfo extends StatefulWidget {
  TeamInfo(
      {required this.adminMobile,
      required this.adminName,
      required this.farmName,
      Key? key})
      : super(key: key);
  final String adminMobile;
  final String adminName;
  final String farmName;

  @override
  State<TeamInfo> createState() => _TeamInfoState(
      adminMobile: adminMobile, adminName: adminName, farmName: farmName);
}

class _TeamInfoState extends State<TeamInfo> {
  _TeamInfoState(
      {required this.adminMobile,
      required this.adminName,
      required this.farmName});

  String adminMobile;
  String adminName;
  String farmName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      child: ExpandBox(
        title: '团队信息',
        infoMap: {
          '养殖场名称': farmName,
          '主账号昵称': adminName,
          '主账号手机号': adminMobile,
        },
        isEnd: true,
      ),
    );
  }
}

/// 基本信息
class BasicInfo extends StatefulWidget {
  BasicInfo(
      {required this.expireTime,
      required this.mobile,
      required this.isAdmin,
      Key? key})
      : super(key: key);
  final String expireTime;
  final String mobile;
  final bool isAdmin;

  @override
  State<BasicInfo> createState() =>
      _BasicInfoState(expireTime: expireTime, mobile: mobile, isAdmin: isAdmin);
}

class _BasicInfoState extends State<BasicInfo> {
  _BasicInfoState(
      {required this.expireTime, required this.mobile, required this.isAdmin});

  String expireTime;
  String mobile;
  bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TitleBox(title: '基本信息'),
          ExpandBox(
              title: '个人信息',
              infoMap: {'用户账号': mobile, '权限期限': expireTime},
              isEnd: false),
          ExpandBox(
              title: '密钥权限',
              infoMap:
                  isAdmin ? {'': '主账号权限：子账号管理、AI测耳温'} : {'': '子账号权限：AI测耳温'},
              isEnd: true),
          ExpandBox(
              title: '联系我们',
              infoMap: {'官方网店': '可利农CALINO', '公众号': 'TCY_CALINO'},
              isEnd: true),
        ],
      ),
    );
  }
}

class TwoDimensionalCodeBox extends StatelessWidget {
  TwoDimensionalCodeBox(
      {required this.flag, required this.imgUrl, this.height = 0, Key? key})
      : super(key: key);
  final String imgUrl;
  final int flag; // flag 0 本地, 1 网络
  final double height;
  late final Offset _tapPosition; // 点击坐标

  // 存储点击坐标
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: GestureDetector(
        onLongPress: () {
          final RenderBox overlay =
              Overlay.of(context)?.context.findRenderObject() as RenderBox;
          showMenu(
            context: context,
            items: <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 1,
                height: 20.h,
                child: Text('保存图片'),
              ),
            ],
            position: RelativeRect.fromRect(
                _tapPosition & Size.zero, // smaller rect, the touch area
                Offset.zero & overlay.size // Bigger rect, the entire screen
                ),
          ).then((value) async {
            if (value == 1) {
              if (flag == 0) {
                ByteData bytes;
                if (imgUrl == 'assets/user/userCenter/calinoWechat.png') {
                  bytes = await rootBundle
                      .load('assets/user/userCenter/calinoWechatReturn.png');
                } else {
                  bytes = await rootBundle.load(imgUrl);
                }
                Uint8List imageBytes = bytes.buffer.asUint8List();
                // 保存图片
                final result = await ImageGallerySaver.saveImage(imageBytes);
                if (result == null || result == '')
                  throw '图片保存失败';
                else
                  Toast.show('图片保存成功');
              }
            }
          });
        },
        onTapDown: _storePosition,
        child: Image.asset(
          imgUrl,
          fit: BoxFit.contain,
          color: Colors.white70,
        ),
      ),
    );
  }
}
