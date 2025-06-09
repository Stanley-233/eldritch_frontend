import 'package:eldritch_frontend/services/api_service.dart';
import 'package:eldritch_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../models/order.dart';

class OrderReportPage extends StatefulWidget{
  final Order order;
  OrderReportPage({super.key, required this.order});
  final _contentController = TextEditingController();
  @override
  State<StatefulWidget> createState() => _OrderReportPage();
}

class _OrderReportPage extends State<OrderReportPage>{
  bool accepted = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.order.title),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Markdown(data: widget.order.content),
            ),
            Form(
              key: formKey,
              child: TextFormField(
                controller: widget._contentController,
                decoration: InputDecoration(
                  labelText: '工单反馈',
                  hintText: '请输入内容',
                  border: OutlineInputBorder(), // 边框样式
                ),
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return '请输入内容';
                  }
                  return null;
                },
              ),
            ),
            CheckboxListTile(
                value: accepted,
                onChanged: (value){
                  setState(() {accepted = value!;});
                }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if (formKey.currentState!.validate()) {
            ReportRequest ret =
            ReportRequest(
                orderId: widget.order.orderId,
                content: widget._contentController.text,
                status: accepted ? 'closed' : 'reject',
                createdBy: AuthService().user!.name);
            postReport(ret);
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
