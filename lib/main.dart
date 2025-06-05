import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化认证服务并加载用户
  final authService = AuthService();

  runApp(
    ChangeNotifierProvider(
      create: (_) => authService,
      child: MyApp(),
    ),
  );
}
