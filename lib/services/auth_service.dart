import 'package:eldritch_frontend/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

enum LoginStatus {
  success,
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
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // 登录
  Future<LoginStatus> login(String username, String password) async {
    // _isLoading = true;
    notifyListeners();
    final status = await postAuth(username, password);
    switch (status) {
      case 200:
        _user = User(name: username, password: password);
        _isLoading = false;
        notifyListeners();
        return LoginStatus.success;
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
    final status = await postAuth(username, password);
    switch(status) {
      case 200:
        _user = User(name: username, password: password);
        _isLoading = false;
        notifyListeners();
        return RegisterStatus.success;
      case 201:
        _user = User(name: username, password: password);
        _isLoading = false;
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
