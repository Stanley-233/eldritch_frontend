import 'dart:convert';

class Message{
  final String title;
  final String content;
  final String creatorName;
  List<int> availableGroupID = [];

  Message._receiveBuilder({
    required this.title,
    required this.content,
    required this.creatorName,
  });

  Message({
    required this.title,
    required this.content,
    required this.creatorName,
    required this.availableGroupID,
  });

  factory Message.fromJson(Map<String, dynamic> json){
    return Message._receiveBuilder(
      title: json['title'],
      content: json['content'],
      creatorName: json['created_by']
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

