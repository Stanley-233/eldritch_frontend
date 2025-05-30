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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                if (!_formKey.currentState!.validate()) return;
                                final status = await authService.login(
                                  _usernameController.text,
                                  _passwordController.text,
                                ).timeout(const Duration(seconds: 1));
                                switch (status) {
                                  case LoginStatus.success:
                                    Navigator.pushReplacementNamed(context, '/home');
                                    break;
                                  case LoginStatus.wrongPassword:
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('密码错误')),
                                    );
                                    _passwordController.clear();
                                    break;
                                  case LoginStatus.userNotFound:
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('用户不存在')),
                                    );
                                    _usernameController.clear();
                                    _passwordController.clear();
                                    break;
                                  case LoginStatus.serverError:
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('服务器错误，请稍后再试')),
                                    );
                                    break;
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('连接超时或内部错误，请稍后再试')),
                                );
                              }
                            },
                            child: Text('登录'),
                          ),
                        ),
                        // 登录与注册间隔
                        SizedBox(height: 20),
                        // Register Button
                        SizedBox(
                          width: double.infinity, // 按钮宽度填满可用空间
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                if (_formKey.currentState!.validate()) {
                                  final status = await authService.register(
                                    _usernameController.text,
                                    _passwordController.text,
                                  );
                                  switch (status) {
                                    case RegisterStatus.success:
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('注册成功，请登录')),
                                      );
                                      break;
                                    case RegisterStatus.userExists:
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('用户已存在，请尝试其他用户名')),
                                      );
                                      _usernameController.clear();
                                      break;
                                    case RegisterStatus.serverError:
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('服务器错误，请稍后再试')),
                                      );
                                      break;
                                  }
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('连接超时或内部错误，请稍后再试')),
                                );
                              }
                            },
                            child: Text('注册'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            )
          ),
        ),
      ),
    );
  }
}
