class UserGroup {
  int groupId;
  String groupName;
  String groupDescription;
  bool canSendMessage;

  UserGroup({
    this.groupId = -1,
    required this.groupName,
    required this.groupDescription,
    required this.canSendMessage,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(
      groupId: json['group_id'],
      groupName: json['group_name'],
      groupDescription: json['group_description'],
      canSendMessage: json['can_send_message'] ?? false,
    );
  }
}
