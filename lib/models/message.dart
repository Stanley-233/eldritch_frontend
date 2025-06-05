import 'dart:convert';

class Message{
  final String title;
  final String content;
  final String creatorName;
  final DateTime createdAt;
  List<int> availableGroupID = [];

  Message._receiveBuilder({
    required this.title,
    required this.content,
    required this.creatorName,
    required this.createdAt
  });

  Message({
    required this.title,
    required this.content,
    required this.creatorName,
    required this.createdAt,
    required this.availableGroupID,
  });

  factory Message.fromJson(Map<String, dynamic> json){
    return Message._receiveBuilder(
      title: json['title'],
      content: json['content'],
      creatorName: json['created_by'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  String toJson(){
    return jsonEncode({
      'title' : title,
      'content' : content,
      'created_by' : creatorName,
      'access_groups_ids' : availableGroupID,
    });
  }
}

