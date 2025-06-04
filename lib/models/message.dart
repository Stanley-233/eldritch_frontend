import 'dart:convert';

class Message{
  final String title;
  final String content;
  final String creatorName;
  int availableGroupID = -1;

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
      creatorName: json['creatorName']
    );
  }

  String toJson(){
    return jsonEncode({
      'title' : title,
      'content' : content,
      'creatorName' : creatorName,
      'toGroup' : availableGroupID,
    });
  }
}

