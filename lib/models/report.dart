class Report {
  final String content;
  final String createdBy;
  final DateTime createdAt;

  Report({
    required this.content,
    required this.createdBy,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      content: json['content'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}