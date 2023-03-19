import 'package:calino/home/report.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SpUtil._();

  static late SharedPreferences sharedPref;

  static Future<void> init() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  static final isLogin = Prefs<bool>('isLogin', false);

  static final accessToken = Prefs<String>('accessToken', '');
  static final refreshToken = Prefs<String>('refreshToken', '');
  static final expiresTime = Prefs<String>('expiresTime', '');
  static final userData = Prefs<String>('userData', '');

  static final countPics = Prefs<List>('countPics', []);
  static final identityPics = Prefs<List>('identityPics', []);
  static final identityCount = Prefs<List>('identityCount', ['0', '0', '0']);

  static List<int> get count {
    var list = [0, 0, 0];
    list[0] = int.parse(identityCount.value[0]);
    list[1] = int.parse(identityCount.value[1]);
    list[2] = int.parse(identityCount.value[2]);
    return list;
  }

  static List<String> format(List<int> list) => list.map((e) => '$e').toList();

  static bool get identifyFull => count.every((e) => e == 3);

  static bool get identifyEmpty => count.every((e) => e == 0);

  static int get identifyIndex =>
      count[0] == 3
          ? count[1] == 3
          ? 2
          : 1
          : 0;

  static void identifyClear() {
    identityPics.value = [];
    identityCount.value = ['0', '0', '0'];
  }

  static void addPic(String path, PigFuncType type) {
    if (type == PigFuncType.COUNT) {
      var copy = countPics.value.toList();
      copy.add(path);
      countPics.value = copy;
    } else {
      var copy1 = identityPics.value.toList();
      copy1.add(path);
      identityPics.value = copy1;
      var copy2 = count;
      if (count[0] < 3)
        copy2[0]++;
      else if (count[1] < 3)
        copy2[1]++;
      else
        copy2[2]++;
      identityCount.value = format(copy2);
    }
  }

  static void delPic(String path, PigFuncType type) {
    if (type == PigFuncType.COUNT) {
      var copy = countPics.value.toList();
      copy.remove(path);
      countPics.value = copy;
    } else {
      var copy1 = identityPics.value.toList();
      var index = copy1.indexOf(path);
      index++;
      var copy2 = count;
      if (index > count[0]) {
        index -= count[0];
        if (index > count[1]) {
          copy2[2]--;
        } else {
          copy2[1]--;
        }
      } else {
        copy2[0]--;
      }
      identityCount.value = format(copy2);
      copy1.remove(path);
      identityPics.value = copy1;
    }
  }

  static List getPics(PigFuncType type) =>
      type == PigFuncType.COUNT ? countPics.value : identityPics.value;

  static void logout() {
    isLogin.clear();
    accessToken.clear();
    refreshToken.clear();
    expiresTime.clear();
    userData.clear();
  }
}

class Prefs<T> with PrefsUtil<T> {
  Prefs(this._key, [this._default]) {
    if (_default == null) _default = _getDefaultValue();
  }

  String _key;
  T? _default;

  T get value => _getValue(_key) ?? _default;

  set value(T newValue) => _setValue(newValue, _key);

  void clear() => _clearValue(_key);
}

mixin PrefsUtil<T> {
  static SharedPreferences get pref => SpUtil.sharedPref;

  dynamic _getValue(String key) => pref.get(key);

  _setValue(T value, String key) async {
    switch (T) {
      case String:
        await pref.setString(key, value as String);
        break;
      case bool:
        await pref.setBool(key, value as bool);
        break;
      case int:
        await pref.setInt(key, value as int);
        break;
      case double:
        await pref.setDouble(key, value as double);
        break;
      case List:
        await pref.setStringList(
            key, (value as List).map((e) => '$e').toList());
        break;
    }
  }

  void _clearValue(String key) async => await pref.remove(key);

  dynamic _getDefaultValue() {
    switch (T) {
      case String:
        return '';
      case int:
        return 0;
      case double:
        return 0.0;
      case bool:
        return false;
      case List:
        return [];
      default:
        return null;
    }
  }
}
