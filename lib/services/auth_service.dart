import 'dart:convert';  // 添加这行
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // 从本地存储加载用户
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      _user = User.fromJson(Map<String, dynamic>.from(json.decode(userJson)));
    }

    _isLoading = false;
    notifyListeners();
  }

  // 登录
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    // 模拟API调用
    // await Future.delayed(Duration(seconds: 2));

    // 这里应该是真实的API调用
    // final response = await http.post(...);

    // 模拟成功登录
    _user = User(
      name: username,
      password: password
    );

    // 保存用户到本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(_user!.toJson()));

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // 登出
  Future<void> logout() async {
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    notifyListeners();
  }
}
