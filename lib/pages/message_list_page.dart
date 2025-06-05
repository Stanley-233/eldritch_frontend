import 'package:eldritch_frontend/pages/message_add_page.dart';
import 'package:eldritch_frontend/services/msg_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/message.dart';
import '../services/auth_service.dart';
import 'message_view_page.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});
  @override
  State<StatefulWidget> createState() => _CertainMessageState();
}

class _CertainMessageState extends State<StatefulWidget> {
  late Future<List<Message>> _messagesList;

  @override
  Widget build(BuildContext context) {
    final username = AuthService().user?.name;
    return Scaffold(
      appBar: AppBar(
        title: Text('消息列表'),
      ),
      body: FutureBuilder<Response> (
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
              if(response!.statusCode != 200) {
                if(response.statusCode == 404){
                  return Center(
                    child: Text('用户不存在，请重新登录'),
                  );
                }
                return Center(
                  child: Text("服务器内部错误"),
                );
              }
              final messageList = extractFromJson(response.body);
              return ListView.separated(
                itemCount: messageList.length,
                itemBuilder: (BuildContext context, int index) {
                  String subtitle;
                  if(messageList[index].content.length < 30){
                    subtitle = messageList[index].content;
                  }else{
                    subtitle = messageList[index].content.substring(0, 25);
                  }
                  return ListTile(
                      title: Text(messageList[index].title),
                      subtitle: Text(subtitle),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageViewPage(message: messageList[index]),
                          ),
                        );
                      }
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 0,
                    thickness: 10,
                    color: Colors.grey,
                    indent: 20,
                    endIndent: 20,
                  );
                },
              );
            }
          }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => MessageAddPage()
          ));
        },
        label: const Text('发送消息'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}