import 'dart:convert';

import 'package:eldritch_frontend/models/message.dart';
import 'package:http/http.dart' as http;

final apiUrl = "http://127.0.0.1:23353";

class postMessageRequest {
  final String title;
  final String content;
  final String createdBy;
  final List<int> accessGroupIds;

  postMessageRequest({
    required this.title,
    required this.content,
    required this.createdBy,
    required this.accessGroupIds,
  });
}

Future<http.Response> postUsername(String username) async {
  final url = Uri.parse('$apiUrl/message');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username
    })
  );
  return response;
}

Future<int> postMessage(postMessageRequest request) async {
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

List<Message> extractFromJson(String json){
  dynamic parsedJson = jsonDecode(json);
  if (parsedJson is List){
    return parsedJson.map((e) => Message.fromJson(e)).toList();
  }
  return [];
}
