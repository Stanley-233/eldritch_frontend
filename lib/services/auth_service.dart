import 'dart:convert';

import 'package:eldritch_frontend/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

enum LoginStatus {
  success,
  adminSuccess,
  wrongPassword,
  userNotFound,
  serverError
}

enum RegisterStatus {
  success,
  adminSuccess,
  userExists,
  serverError
}

class AuthService with ChangeNotifier {
  static final AuthService _instance = AuthService._internal();

  User? _user;
  bool _isLoading = false;
  String accessToken = "";

  User? get user => _user;
  bool get isLoading => _isLoading;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // 登录
  Future<LoginStatus> login(String username, String password) async {
    // _isLoading = true;
    notifyListeners();
    final response = await postLogin(username, password);
    switch (response.statusCode) {
      case 200:
        _user = User(name: username, password: password);
        _isLoading = false;
        accessToken = jsonDecode(response.body)['token'] ?? '';
        notifyListeners();
        return LoginStatus.success;
      case 201:
        _user = User(name: username, password: password, isAdmin: true);
        _isLoading = false;
        accessToken = jsonDecode(response.body)['token'] ?? '';
        notifyListeners();
        return LoginStatus.adminSuccess;
      case 403:
        _isLoading = false;
        notifyListeners();
        return LoginStatus.wrongPassword;
      case 404:
        _isLoading = false;
        notifyListeners();
        return LoginStatus.userNotFound;
      default:
        _isLoading = false;
        notifyListeners();
        return LoginStatus.serverError;
    }
  }

  Future<RegisterStatus> register(String username, String password) async {
    // _isLoading = true;
    notifyListeners();
    final response = await postRegister(username, password);
    switch(response.statusCode) {
      case 200:
        _user = User(name: username, password: password);
        _isLoading = false;
        accessToken = response.headers['token'] ?? '';
        notifyListeners();
        return RegisterStatus.success;
      case 201:
        _user = User(name: username, password: password, isAdmin: true);
        _isLoading = false;
        accessToken = response.headers['token'] ?? '';
        notifyListeners();
        return RegisterStatus.adminSuccess;
      case 409:
        _isLoading = false;
        notifyListeners();
        return RegisterStatus.userExists;
      default:
        _isLoading = false;
        notifyListeners();
        return RegisterStatus.serverError;
    }
  }

  // 登出
  Future<void> logout() async {
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    notifyListeners();
  }
}
