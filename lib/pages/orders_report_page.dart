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
      appBar: AppBar(
        title: const Text('工单反馈'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 1200 ? 1200 : MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            children: [
              Text(
                widget.order.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width > 1200 ? 1200 : MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 400,
                child: Markdown(data: widget.order.content),
              ),
              SizedBox(height: 10),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: widget._contentController,
                  maxLines: 2,
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
              SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('是否审批通过?'),
                value: accepted,
                onChanged: (value){
                  setState(() {accepted = value!;});
                }
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            ReportRequest ret =
            ReportRequest(
                orderId: widget.order.orderId,
                content: widget._contentController.text,
                status: accepted ? 'closed' : 'reject',
                createdBy: AuthService().user!.name);
            final code = await postReport(ret);
            if (code == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('反馈成功')));
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('反馈失败')));
            }
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
