import 'package:card_settings_ui/card_settings_ui.dart';
import 'package:eldritch_frontend/pages/about_page.dart';
import 'package:eldritch_frontend/pages/group_list_page.dart';
import 'package:eldritch_frontend/pages/user_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});
  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService().user;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('系统管理'),
        ),
        body: Center(
          child: SizedBox(
            width: (MediaQuery.of(context).size.width > 1000) ? 1000 : null,
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: Text('系统管理'),
                  tiles: [
                    SettingsTile(
                      title: Text('用户总览'),
                      description: Text('查看用户列表并管理'),
                      leading: Icon(Icons.person),
                      onPressed: (context) {
                        if (user!.isAdmin) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserViewPage(),
                            ),
                          );
                        }
                        else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('权限不足'),
                                content: Text('您不是系统管理员，无法访问此页面。'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('确定'),
                                  ),
                                ],
                              );
                            }
                          );
                        }
                      },
                    ),
                    SettingsTile(
                      title: Text('用户组总览'),
                      description: Text('查看用户组列表并管理'),
                      leading: Icon(Icons.groups),
                      onPressed: (context) {
                        if (user!.isAdmin) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupListPage(),
                            ),
                          );
                        }
                        else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('权限不足'),
                                  content: Text('您不是系统管理员，无法访问此页面。'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('确定'),
                                    ),
                                  ],
                                );
                              }
                          );
                        }
                      },
                    )
                  ],
                ),
                SettingsSection(
                  title: Text('其他'),
                  tiles: [
                    SettingsTile(
                      title: Text('关于'),
                      leading: Icon(Icons.info_outline),
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutPage()
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            )
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final authService = Provider.of<AuthService>(context, listen: false);
            await authService.logout();
            if (context.mounted) {
              Navigator.pushReplacementNamed((context), '/login');
            }
          },
          tooltip: '退出登录',
          child: const Icon(Icons.logout),
        ),
      ),
    );
  }
}
