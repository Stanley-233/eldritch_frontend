import 'package:http/http.dart';
import 'package:eldritch_frontend/services/msg_service.dart';
import 'package:flutter/material.dart';
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
    return FutureBuilder<Response> (
      future: postUsername(username!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Unknown Error');
        } else {
          // 成功的
          final response = snapshot.data;
          if(response!.statusCode != 200) {
            return Text('Unknown Error');
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
    );
  }
}