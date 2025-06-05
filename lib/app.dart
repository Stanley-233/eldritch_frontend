import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'routes.dart';
import 'services/auth_service.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eldritch 办公自动化工单系统',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: kIsWasm || kIsWeb ? 'Roboto' : Platform.isWindows ? 'Microsoft YaHei' : 'Roboto',
      ),
      routes: AppRoutes.routes,
      home: Consumer<AuthService>(
        builder: (context, authService, child) {
          if (authService.isLoading) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            return authService.user == null ? LoginPage() : HomePage();
          }
        },
      ),
    );
  }
}
