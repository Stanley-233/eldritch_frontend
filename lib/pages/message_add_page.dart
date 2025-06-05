import 'dart:convert';

import 'package:eldritch_frontend/services/api_service.dart';
import 'package:eldritch_frontend/services/auth_service.dart';
import 'package:eldritch_frontend/services/msg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class MessageAddPage extends StatefulWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  @override
  State<MessageAddPage> createState() => _MessageAddPageState();
}

class _MessageAddPageState extends State<MessageAddPage> {
  String markdownContent = "";
  List<int> needToBeSend = [];

  @override
  void initState() {
    super.initState();
    markdownContent = widget.contentController.text;
  }

  @override
  Widget build(BuildContext context) {
    needToBeSend = [];
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新建消息'),
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
              child: Column(
                children: [
                  TextFormField(
                    controller: widget.titleController,
                    decoration: const InputDecoration(
                      labelText: '消息标题',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '消息标题不可为空';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: widget.contentController,
                    decoration: const InputDecoration(
                      labelText: '消息内容',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 12,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '消息内容不可为空';
                      }
                      return null;
                    },
                  ),
                  FutureBuilder(
                      future: getUserGroups(AuthService().user!.name),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(),
                              )
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('无法连接到服务器'),
                          );
                        }
                        else {
                          final response = snapshot.data!;
                          final groupList = extractGroupsFromJson(utf8.decode(
                              response.bodyBytes));
                          if (response.statusCode != 200) {
                            if (response.statusCode == 404) {
                              return Center(
                                child: Text('用户不存在，请重新登录'),
                              );
                            }
                            return Center(
                              child: Text("服务器内部错误"),
                            );
                          }
                          if (groupList.isEmpty) {
                            return Center(
                              child: Text('暂无用户组'),
                            );
                          }
                          return ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                return CheckboxListTile(
                                    title: Text(groupList[index].groupName),
                                    value: false,
                                    onChanged: (bool? value) {
                                      if (value!) {
                                        needToBeSend.add(
                                            groupList[index].groupId);
                                      }
                                      else {
                                        needToBeSend.remove(
                                            groupList[index].groupId);
                                      }
                                    }
                                );
                              },
                              itemCount: groupList.length,
                              separatorBuilder: (BuildContext context,
                                  int index) {
                                return Divider(
                                  height: 2.0,
                                  color: Colors.transparent,
                                );
                              }
                          );
                        }
                      }
                  ),
                  const SizedBox(height: 10),
                  /*const Text(
                    "消息预览",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width > 400) ? 400 : null,
                    height: 300,
                    child: Markdown(
                      data: widget.contentController.text,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 16, height: 1.5),
                        h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        code: const TextStyle(fontFamily: 'Courier', fontSize: 14),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        markdownContent = widget.contentController.text;
                      });
                    },
                    child: Text("刷新 Markdown 预览"),
                  )*/
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              postMessage(
                PostMessageRequest(
                  title: widget.titleController.text,
                  content: widget.contentController.text,
                  createdBy: AuthService().user!.name,
                  accessGroupIds: needToBeSend
                )
              );
            });
          },
          tooltip: "发送消息",
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}
