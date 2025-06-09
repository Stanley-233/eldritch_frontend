import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../models/message.dart';

class MessageView extends StatelessWidget{
  final Message message;
  const MessageView({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(message.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer, // 背景颜色
              borderRadius: BorderRadius.circular(12.0), // 圆角
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // 阴影偏移
                ),
              ],
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    message.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 1000 ? 1000 : MediaQuery.of(context).size.width - 50,
                    height: MediaQuery.of(context).size.height - 200,
                    child: Markdown(
                      data: message.content,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 14),
                        h1: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        h2: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        h3: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${message.creatorName} 于 ${message.createdAt.toLocal().toString().split(' ').join(' ').substring(0, 19)}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          ),
        )
      )
    );
  }
}