import 'dart:convert';

import 'package:eldritch_frontend/models/order.dart';
import 'package:eldritch_frontend/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:http/http.dart';

import '../models/report.dart';

class OrderView extends StatelessWidget{
  final Order order;

  const OrderView({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    String orderStatus = "";
    if (order.status == "open") {
      orderStatus = "处理中";
    } else if (order.status == "reject") {
      orderStatus = "驳回";
    } else if (order.status == "closed") {
      orderStatus = "已反馈";
    }
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(order.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                order.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width > 1000 ? 1000 : MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 200,
                child: Markdown(
                  data: order.content,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 14),
                    h1: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    h2: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    h3: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "${order.createdBy} 于 ${order.createdAt.toLocal().toString().split(' ').join(' ').substring(0, 19)}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              // Text(
              //   "修改于 ${order.updatedAt.toLocal().toString().split(' ').join(' ').substring(0, 19)}",
              //   style: const TextStyle(fontSize: 14, color: Colors.grey),
              // ),
            ],
          )
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final response = await getOrderReport(order.orderId);
            if (response.statusCode == 200) {
              // TODO
              final report = Report.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("反馈信息"),
                    content: Column(
                      children: [
                        Text("反馈内容：${report.content}"),
                        const SizedBox(height: 5),
                        Text("处理意见：$orderStatus"),
                        Text(
                          "${report.createdBy} 于 ${report.createdAt.toLocal().toString().split(' ').join(' ').substring(0, 19)}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey)
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("确定")
                      )
                    ]
                  );
                }
              );
            } else if (response.statusCode == 401) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("暂无反馈"),
                    content: const Text("暂无反馈"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("确定")
                      )
                    ]
                  );
                }
              );
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('连接超时或内部错误，请稍后再试')),
              );
            }
          },
          label: Text("查看反馈"),
          icon: const Icon(Icons.text_snippet)
        ),
      )
    );
  }
}