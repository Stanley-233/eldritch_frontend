import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('用户登录')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 4, // 阴影效果
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 使Column只占用所需空间
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(labelText: '用户名'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入你的用户名';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: '密码'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入你的密码';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        if (authService.isLoading)
                          CircularProgressIndicator()
                        else
                          SizedBox(
                            width: double.infinity, // 按钮宽度填满可用空间
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await authService.login(
                                    _usernameController.text,
                                    _passwordController.text,
                                  );

                                  if (success) {
                                    Navigator.pushReplacementNamed(context, '/home');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('登陆失败')),
                                    );
                                  }
                                }
                              },
                              child: Text('登录'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}
