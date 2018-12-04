import 'package:flutter/material.dart';

typedef Widget WidgetBuilder(BuildContext context, Map urlParams, {Map params});

class _Router {
  String name;
  WidgetBuilder widgetBuilder;
  List<_Router> _children = [];

  _Router({this.name, this.widgetBuilder});

  List<_Router> get children => List.unmodifiable(_children);

  addChild(_Router child) {
    _children.add(child);
  }
}

class Router {
  static var _routerEntry = _Router(name: '');

  // param should wrap with {}, eg: /movie/{id}
  static register(String pattern, WidgetBuilder widgetBuilder) {
    final patternSections = pattern.split('/');
    var routerEntry = _routerEntry;
    for (int i = 0; i < patternSections.length; i++) {
      final _pattern = patternSections[i];
      final _router = _Router(name: _pattern);
      if (i == patternSections.length - 1) {
        _router.widgetBuilder = widgetBuilder;
      }
      routerEntry.addChild(_router);
      routerEntry = _router;
    }
  }

  static Widget getWidget(String url, BuildContext context, {Map params}) {
    final urlSections = url.split('/');
    var routerEntry = _routerEntry;
    Widget widget;
    Map urlParams = {};

    for (int i = 0; i < urlSections.length; i++) {
      final _urlSection = urlSections[i];
      var found = false;
      for (_Router _router in routerEntry.children) {
        if (_router.name == _urlSection || _router.name.startsWith('{')) {
          if (_router.name.startsWith('{')) {
            final param = _router.name.substring(1, _router.name.length - 1);
            urlParams[param] = _urlSection;
          }
          found = true;
          routerEntry = _router;
          if (i == urlSections.length - 1) {
            if (_router.widgetBuilder != null) {
              widget =
                  _router.widgetBuilder(context, urlParams, params: params);
            }
          }
        }
      }

      if (!found) {
        break;
      }
    }

    return widget;
  }
}
