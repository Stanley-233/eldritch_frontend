import 'package:flutter/material.dart';

import '../models/user_group.dart';
import '../services/user_view_service.dart';

class GroupAddPage extends StatefulWidget {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  bool canSendMessage = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新建用户组'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: (MediaQuery.of(context).size.width > 800) ? 800 : null,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: widget.titleController,
                      decoration: const InputDecoration(
                        labelText: '用户组名',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '用户组名不可为空';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: widget.contentController,
                      decoration: const InputDecoration(
                        labelText: '用户组描述',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    // 选择用户是否可以发送信息
                    CheckboxListTile(
                      title: const Text("用户组下达任务权限"),
                      value: canSendMessage,
                      onChanged: (bool? value) {
                        setState(() {
                          canSendMessage = value ?? false;
                        });
                      },
                    )
                  ],
                ),
              )
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // TODO: 保存用户组信息
            if (_formKey.currentState?.validate() != true) {
              return;
            }
            final newGroup = UserGroup(
              groupName: widget.titleController.text,
              groupDescription: widget.contentController.text,
              canSendMessage: this.canSendMessage,
            );
            final response = await createGroup(newGroup);
            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('用户组创建成功')),
              );
              Navigator.pop(context, true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('创建用户组失败: ${response.reasonPhrase}')),
              );
            }
          },
          tooltip: "保存用户组",
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
