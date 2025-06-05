import 'dart:convert';

import 'package:eldritch_frontend/pages/message_add_page.dart';
import 'package:eldritch_frontend/services/msg_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../services/auth_service.dart';
import '../widgets/message_view.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});

  @override
  State<StatefulWidget> createState() => _CertainMessageState();
}

class _CertainMessageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final username = AuthService().user?.name;
    return Scaffold(
      appBar: AppBar(
        title: Text('消息列表'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Response>(
          future: postUsername(username!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
            } else {
              // 成功的
              final response = snapshot.data;
              if (response!.statusCode != 200) {
                if (response.statusCode == 404) {
                  return Center(
                    child: Text('用户不存在，请重新登录'),
                  );
                } else if (response.statusCode == 403) {
                  return Center(
                    child: Text('用户不属于任何组'),
                  );
                }
                return Center(
                  child: Text("服务器内部错误"),
                );
              }
              final messageList = extractFromJson(utf8.decode(response.bodyBytes));
              if (messageList.isEmpty) {
                return Center(
                  child: Text('暂无消息'),
                );
              }
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.separated(
                    itemCount: messageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String subtitle;
                      if (messageList[index].content.length < 30) {
                        subtitle = messageList[index].content;
                      } else {
                        subtitle = messageList[index].content.substring(0, 25);
                      }
                      return ListTile(
                          title: Text(messageList[index].title),
                          subtitle: Text(subtitle),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessageView(
                                    message: messageList[index]),
                              ),
                            );
                          }
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 2.0,
                        color: Colors.transparent,
                      );
                    }
                  )
                )
              );
            }
          })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => MessageAddPage()));
        },
        label: const Text('发送消息'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
