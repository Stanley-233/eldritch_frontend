import 'dart:convert';

class Order{
  final String title;
  final String content;
  final String status;
  List<int> assignedGroups = [];
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order._receiveBuilder({
    required this.title,
    required this.content,
    required this.status,
    required this.assignedGroups,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Order({
    required this.title,
    required this.content,
    required this.status,
    required this.assignedGroups,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json){
    return Order._receiveBuilder(
      title: json['title'],
      content: json['content'],
      status: json['status'],
      assignedGroups: List<int>.from(json['assigned_groups'] ?? []),
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String())
    );
  }

  String toJson(){
    return jsonEncode({
      'title' : title,
      'content' : content,
      'assigned_groups' : assignedGroups,
      'created_by' : createdBy,
    });
  }
}

