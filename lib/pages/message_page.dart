import 'dart:ffi';
import 'package:http/http.dart';
import 'package:eldritch_frontend/services/msg_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../services/auth_service.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});
  @override
  State<StatefulWidget> createState() => _CertainMessageState();
}

class _CertainMessageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final username = AuthService().user?.name;
    return
      ListView.builder(
          itemCount:10,
          prototypeItem:ListTile(title: Text('1')),
          itemBuilder: (context, index){return BackButton();}
      );
  }
}