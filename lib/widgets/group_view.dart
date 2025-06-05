import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../models/message.dart';
import '../models/user_group.dart';

class GroupView extends StatelessWidget{
  final UserGroup group;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  GroupView({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(group.groupName),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SizedBox(
            width: (MediaQuery.of(context).size.width > 800) ? 800 : null,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  group.groupName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 40),
                Text(
                  group.groupDescription,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 40),
                CheckboxListTile(
                  title: const Text("用户组下达非对称消息权限"),
                  value: group.canSendMessage,
                  onChanged: (value) {},
                )
              ]
            )
          )
        )
      )
    );
  }
}
