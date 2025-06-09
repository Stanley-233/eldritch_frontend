import 'dart:convert';

import 'package:eldritch_frontend/models/user_group.dart';
import 'package:eldritch_frontend/services/api_service.dart';
import 'package:eldritch_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';

class OrderAddPage extends StatefulWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  OrderAddPage({super.key});
  @override
  State<OrderAddPage> createState() => _OrderAddPageState();
}

class _OrderAddPageState extends State<OrderAddPage> {
  String markdownContent = "";
  List<bool> isChecked = [];
  List<int> needToBeSend = [];
  List<UserGroup> groupList = []; // 存储用户组数据
  bool isLoading = true; // 加载状态

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    markdownContent = widget.contentController.text;
    _loadGroupList(); // 初始化时加载用户组数据
  }

  void _loadGroupList() async {
    try {
      final response = await getGroupList();
      if (response.statusCode == 200) {
        groupList = extractGroupsFromJson(utf8.decode(response.bodyBytes));
        isChecked = List<bool>.filled(groupList.length, false);
      } else {
        // 处理错误状态
        groupList = [];
      }
    } catch (e) {
      groupList = [];
    } finally {
      setState(() {
        isLoading = false; // 加载完成
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新建工单'),
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
                          labelText: '工单标题',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '工单标题不可为空';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: widget.contentController,
                        decoration: const InputDecoration(
                          labelText: '工单内容',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 12,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '工单内容不可为空';
                          }
                          return null;
                        },
                      ),
                      isLoading ? Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(),
                        ),
                      ) : groupList.isEmpty ? Center(
                        child: Text('暂无用户组'),
                      ) : SizedBox(
                        width: MediaQuery.of(context).size.width > 800 ? 800 : MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return CheckboxListTile(
                              title: Text(groupList[index].groupName),
                              value: isChecked[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked[index] = value!;
                                  if (value) {
                                    needToBeSend.add(groupList[index].groupId);
                                  } else {
                                    needToBeSend.remove(groupList[index].groupId);
                                  }
                                });
                              },
                            );
                          },
                          itemCount: groupList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 2.0,
                              color: Colors.transparent,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() != true) {
              return;
            }
            final code = await postMessage(
              PostMessageRequest(
                title: widget.titleController.text,
                content: widget.contentController.text,
                createdBy: AuthService().user!.name,
                accessGroupIds: needToBeSend,
              ),
            );
            if (code == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('工单提交成功')),
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('工单提交失败，错误代码：$code')),
              );
            }
          },
          tooltip: "提交工单",
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}
