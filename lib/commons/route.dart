import 'package:flutter/material.dart';

/// 封装[Navigator]
class Ex {
  Ex._();

  /// [next] push到达的页面
  /// [routeBuilder] 自定义PageRoute，传入[next]作为参数
  static Future<T?> push<T extends Object?>(BuildContext context, Widget next,
      [Route<T> Function(Widget p)? routeBuilder]) async {
    Route<T> route;
    if (routeBuilder != null) {
      route = routeBuilder(next);
    } else {
      route = MaterialPageRoute(builder: (_) => next);
    }
    T? t = await Navigator.push<T>(context, route);
    return t;
  }

  /// [next] push到达的页面
  /// [routeBuilder] 自定义PageRoute，传入[next]作为参数
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
      BuildContext context, Widget next,
      [Route<T> Function(Widget p)? routeBuilder]) async {
    Route<T> route;
    if (routeBuilder != null) {
      route = routeBuilder(next);
    } else {
      route = MaterialPageRoute(builder: (_) => next);
    }
    T? t = await Navigator.pushAndRemoveUntil<T>(context, route, (_) => false);
    return t;
  }

  /// [next] push到达的页面
  /// [routeBuilder] 自定义PageRoute，传入[next]作为参数
  static Future<T?> pushReplacement<T extends Object?>(
      BuildContext context, Widget next,
      [Route<T> Function(Widget p)? routeBuilder]) async {
    Route<T> route;
    if (routeBuilder != null) {
      route = routeBuilder(next);
    } else {
      route = MaterialPageRoute(builder: (_) => next);
    }
    T? t = await Navigator.pushReplacement(context, route);
    return t;
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) =>
      Navigator.pop<T>(context, result);
}
