import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/login': (context) => LoginPage(),
    '/home': (context) => HomePage(),
  };
}
