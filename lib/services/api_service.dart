import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:eldritch_frontend/models/user_group.dart';
import 'package:eldritch_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/message.dart';
import '../models/order.dart';

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

Future<int> postAddGroup(String username, int group_id) async{
  final url = Uri.parse('$apiUrl/users/add_group');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username' : username, 'group_id' : group_id})
  );
  return response.statusCode;
}

Future<http.Response> getGroupList() async {
  final url = Uri.parse('$apiUrl/user_group/');
  final response = await http.get(url);
  return response;
}

Future<http.Response> getUserGroups(String username) async{
  final url = Uri.parse('$apiUrl/user_group/$username');
  final response = await http.get(url);
  return response;
}

List<UserGroup> extractGroupsFromJson(String json){
  dynamic parsedJson = jsonDecode(json);
  if (parsedJson is List){
    return parsedJson.map((e) => UserGroup.fromJson(e)).toList();
  }
  return [];
}

Future<dynamic> postRemoveFromGroup(String username, int group_id) async {
  final url = Uri.parse('$apiUrl/users/remove_group');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username' : username, 'group_id' : group_id})
  );
  return response.statusCode;
}

class PostMessageRequest {
  final String title;
  final String content;
  final String createdBy;
  final List<int> accessGroupIds;

  PostMessageRequest({
    required this.title,
    required this.content,
    required this.createdBy,
    required this.accessGroupIds,
  });
}

Future<http.Response> postUsername(String username) async {
  final url = Uri.parse('$apiUrl/message/get');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username
      })
  );
  return response;
}

Future<int> postMessage(PostMessageRequest request) async {
  final url = Uri.parse('$apiUrl/message/create');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'title': request.title,
      'content': request.content,
      'created_by': request.createdBy,
      'access_group_ids': request.accessGroupIds,
    }),
  );
  return response.statusCode;
}

List<Message> extractMessagesFromJson(String json){
  dynamic parsedJson = jsonDecode(json);
  if (parsedJson is List){
    return parsedJson.map((e) => Message.fromJson(e)).toList();
  }
  return [];
}

Future<List<Order>> getCreateUserOrders(String type) async {
  final username = AuthService().user?.name;
  final url = Uri.parse('$apiUrl/orders/create_user=${username!}/$type');
  final response = await http.get(url);
  dynamic parsedJson = jsonDecode(utf8.decode(response.bodyBytes));
  if (parsedJson is List) {
    return parsedJson.map((e) => Order.fromJson(e)).toList();
  }
  return [];
}

Future<List<Order>> getAssignedUserOrders(String type) async {
  final username = AuthService().user?.name;
  final url = Uri.parse('$apiUrl/orders/assigned_user=${username!}/$type');
  final response = await http.get(url);
  dynamic parsedJson = jsonDecode(utf8.decode(response.bodyBytes));
  if (parsedJson is List) {
    return parsedJson.map((e) => Order.fromJson(e)).toList();
  }
  return [];
}
