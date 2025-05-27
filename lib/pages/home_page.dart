import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _FunctionAreaState();
}

class _FunctionAreaState extends State<StatefulWidget> {
  int funID = 0;

  void _messageMode() {
    setState(() {
      funID = 0;
    });
  }

  void _commitMode() {
    setState(() {
      funID = 1;
    });
  }

  void _feedbackMode() {
    setState(() {
      funID = 2;
    });
  }

  void _manageMode() {
    setState(() {
      funID = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user!;
    //按钮大小
    const double buttonWidth = 48 * 1.618;
    const double buttonHeight = 48;
    //UI颜色
    final Map<int, Color> buttonColors = {
      0: Colors.black26, //背景颜色
      1: Colors.purple[200]!, //激活颜色
      2: Colors.purple[300]!, //按下颜色
      3: Colors.purple[100]! //悬停颜色
    };

    return Scaffold(
        appBar: AppBar(
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
        body: Row(children: [
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              onPressed: _messageMode,
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    if (funID != 0) {
                      if (states.contains(WidgetState.hovered)) {
                        return buttonColors[3]!; // 悬停颜色
                      }
                      if (states.contains(WidgetState.pressed)) {
                        return buttonColors[2]!; // 按下颜色
                      }
                      return buttonColors[0]!; // 默认颜色
                    } else {
                      return buttonColors[1]!;//激活颜色
                    }
                  }),
                  minimumSize:
                      WidgetStatePropertyAll(Size(buttonWidth, buttonHeight)),
                  maximumSize:
                      WidgetStatePropertyAll(Size(buttonWidth, buttonHeight))),
              icon: Icon(Icons.mail),
            ),
            IconButton(
                onPressed: _commitMode,
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (funID != 1) {
                        if (states.contains(WidgetState.hovered)) {
                          return buttonColors[3]!; // 悬停颜色
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return buttonColors[2]!; // 按下颜色
                        }
                        return buttonColors[0]!; // 默认颜色
                      } else {
                        return buttonColors[1]!;//激活颜色
                      }
                    }),
                    minimumSize:
                        WidgetStatePropertyAll(Size(buttonWidth, buttonHeight)),
                    maximumSize: WidgetStatePropertyAll(
                        Size(buttonWidth, buttonHeight))),
                icon: Icon(Icons.commit)),
            IconButton(
                onPressed: _feedbackMode,
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (funID != 2) {
                        if (states.contains(WidgetState.hovered)) {
                          return buttonColors[3]!; // 悬停颜色
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return buttonColors[2]!; // 按下颜色
                        }
                        return buttonColors[0]!; // 默认颜色
                      } else {
                        return buttonColors[1]!;//激活颜色
                      }
                    }),
                    minimumSize:
                        WidgetStatePropertyAll(Size(buttonWidth, buttonHeight)),
                    maximumSize: WidgetStatePropertyAll(
                        Size(buttonWidth, buttonHeight))),
                icon: Icon(Icons.notifications)),
            IconButton(
                onPressed: _manageMode,
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (funID != 3) {
                        if (states.contains(WidgetState.hovered)) {
                          return buttonColors[3]!; // 悬停颜色
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return buttonColors[2]!; // 按下颜色
                        }
                        return buttonColors[0]!; // 默认颜色
                      } else {
                        return buttonColors[1]!;//激活颜色
                      }
                    }),
                    minimumSize:
                        WidgetStatePropertyAll(Size(buttonWidth, buttonHeight)),
                    maximumSize: WidgetStatePropertyAll(
                        Size(buttonWidth, buttonHeight))),
                icon: Icon(Icons.manage_accounts))
          ]),
          Center(child: Text('unfinished yet. '))
        ]));
  }
}
