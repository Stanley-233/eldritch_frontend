import 'package:flutter/material.dart';

import '../models/report.dart';

class ReportDialog extends StatelessWidget {
  final Report report;
  final String orderStatus;
  final String? title;

  const ReportDialog({super.key, required this.report, required this.orderStatus, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : Text("反馈信息"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width > 300 ? 300 : MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            children: [
              Text("反馈内容：${report.content}"),
              const SizedBox(height: 5),
              Text("处理意见：$orderStatus"),
              const SizedBox(height: 5),
              Text(
                "${report.createdBy} 于 ${report.createdAt.toLocal().toString().split(' ').join(' ').substring(0, 19)}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("确定"),
        ),
      ],
    );
  }
}