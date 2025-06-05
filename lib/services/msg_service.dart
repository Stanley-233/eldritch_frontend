import 'dart:convert';

import 'package:eldritch_frontend/models/message.dart';
import 'package:http/http.dart' as http;

final apiUrl = "http://127.0.0.1:23353";

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

List<Message> extractFromJson(String json){
  dynamic parsedJson = jsonDecode(json);
  if(parsedJson is List){
    return parsedJson.map((e) => Message.fromJson(e)).toList();
  }
  return [];
}
