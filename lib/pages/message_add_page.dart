import 'package:flutter/material.dart';

class MessageAddPage extends StatefulWidget {
  const MessageAddPage({Key? key}) : super(key: key);
  @override
  _MessageAddPageState createState() => _MessageAddPageState();
}

class _MessageAddPageState extends State<MessageAddPage> {
  @override
  Widget build(BuildContext context) {
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
        body: Text("TODO"),
      )
    );
  }
}

