import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eldritch 办公自动化工单系统',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
