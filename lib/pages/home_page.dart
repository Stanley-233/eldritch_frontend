import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _FunctionAreaState();
}

class _FunctionAreaState extends State<StatefulWidget>{
  int funID = 0;

  void _messageMode(){
    setState(() {
      funID = 0;
    });
  }

  void _commitMode(){
    setState(() {
      funID = 1;
    });
  }

  void _feedbackMode(){
    setState(() {
      funID = 2;
    });
  }

  void _manageMode(){
    setState(() {
      funID = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user!;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: _messageMode,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.purple[200]),
                  minimumSize: WidgetStatePropertyAll(Size(100,50))
                ), child: Text('消息')
              ),
              TextButton(onPressed: _commitMode,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.purple[200]),
                  minimumSize: WidgetStatePropertyAll(Size(100,50))
                ), child: Text('工单提交')),
              TextButton(onPressed: _feedbackMode,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.purple[200]),
                  minimumSize: WidgetStatePropertyAll(Size(100,50))
                ), child: Text('反馈')),
              TextButton(onPressed: _manageMode,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.purple[200]),
                  minimumSize: WidgetStatePropertyAll(Size(100,50))
                ), child: Text('管理')),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: '退出登录',
              onPressed: () async {
                await authService.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: Center(
          
        )
    );
  }
}