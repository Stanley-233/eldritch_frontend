import 'dart:convert';
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
