import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final AuthService authService;

  const LoginCard({
    Key? key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // 阴影效果
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // 使Column只占用所需空间
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: '用户名'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入你的用户名';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
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
                      if (!formKey.currentState!.validate()) return;
                      final status = await authService.login(
                        usernameController.text,
                        passwordController.text,
                      ).timeout(const Duration(seconds: 1));
                      switch (status) {
                        case LoginStatus.success:
                          Navigator.pushReplacementNamed(context, '/home');
                          break;
                        case LoginStatus.wrongPassword:
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('密码错误')),
                          );
                          passwordController.clear();
                          break;
                        case LoginStatus.userNotFound:
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('用户不存在')),
                          );
                          usernameController.clear();
                          passwordController.clear();
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
                      if (formKey.currentState!.validate()) {
                        final status = await authService.register(
                          usernameController.text,
                          passwordController.text,
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
                            usernameController.clear();
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
    );
  }
}