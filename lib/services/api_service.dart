import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

final apiUrl = "http://127.0.0.1:23353";

String hashPassword(String password) {
  var bytes = utf8.encode(password); // 将密码转换为字节数组
  var digest = sha256.convert(bytes); // 使用SHA-256哈希
  return digest.toString();
}

Future<int> postLogin(String username, String password) async {
  // TODO: Remove this debug code in production
  if (username == "debug" || password == "debug") return 200;
  final hashedPassword = hashPassword(password);
  final url = Uri.parse('$apiUrl/auth/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username': username, 'password': hashedPassword}),
  );
  return response.statusCode;
}

Future<int> postRegister(String username, String password) async {
  final hashedPassword = hashPassword(password);
  final url = Uri.parse('$apiUrl/auth/register');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username': username, 'password': hashedPassword}),
  );
  return response.statusCode;
}
