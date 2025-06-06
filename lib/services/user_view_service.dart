import 'dart:convert';
import 'package:eldritch_frontend/models/user_group.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

final apiUrl = "http://127.0.0.1:23353";

Future<http.Response> getUserList() async {
  final url = Uri.parse('$apiUrl/users');
  final response = await http.get(url);
  return response;
}

List<User> extractFromJson(String json){
  dynamic parsedJson = jsonDecode(json);
  if(parsedJson is List){
    return parsedJson.map((e) => User.fromJson(e)).toList();
  }
  return [];
}


List<UserGroup> extractGroupFromJson(String json) {
  dynamic parsedJson = jsonDecode(json);
  if (parsedJson is List) {
    return parsedJson.map((e) => UserGroup.fromJson(e)).toList();
  }
  return [];
}

Future<int> deleteGroup(int groupId) async {
  final url = Uri.parse('$apiUrl/user_group/$groupId');
  final response = await http.delete(url);
  return response.statusCode;
}

Future<http.Response> createGroup(UserGroup newGroup) async {
  final url = Uri.parse('$apiUrl/user_group/create');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'group_name': newGroup.groupName,
      'group_description': newGroup.groupDescription,
      'can_send_message': newGroup.canSendMessage,
    }),
  );
  return response;
}