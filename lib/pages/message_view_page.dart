import 'package:flutter/material.dart';
import '../models/message.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';


class MessageViewPage extends StatelessWidget{
  final Message message;
  const MessageViewPage({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(message.title)),
        body: SingleChildScrollView(
          child:Markdown(data: message.content)
        ),
      ),
    );
  }
}