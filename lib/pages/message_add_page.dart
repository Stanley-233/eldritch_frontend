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

  @override
  void initState() {
    super.initState();
    markdownContent = widget.contentController.text;
  }

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
                      labelText: '任务标题',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '任务标题不可为空';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: widget.contentController,
                    decoration: const InputDecoration(
                      labelText: '任务内容',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 12,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '任务内容不可为空';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
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
              // TODO: Implement message sending logic
            });
          },
          tooltip: "发送消息",
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}
