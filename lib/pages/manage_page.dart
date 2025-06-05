import 'package:card_settings_ui/card_settings_ui.dart';
import 'package:eldritch_frontend/pages/about_page.dart';
import 'package:eldritch_frontend/pages/user_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<StatefulWidget> createState() => _ManagePageState();
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
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: '退出登录',
              onPressed: () async {
                final authService = Provider.of<AuthService>(context, listen: false);
                await authService.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed((context), '/login');
                }
              },
            ),
          ],
        ),
        body: Center(
          child: SizedBox(
            width: (MediaQuery.of(context).size.width > 1000) ? 1000 : null,
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: Text('用户组'),
                  tiles: [
                    SettingsTile(
                      title: Text('新增用户组'),
                      description: Text('创建一个新的用户组'),
                      leading: Icon(Icons.lock),
                      onPressed: (context) {
                        // TODO
                      },
                    )
                  ],
                ),
                SettingsSection(
                  title: Text('用户'),
                  tiles: [
                    SettingsTile(
                      title: Text('用户总览'),
                      description: Text('查看用户列表并管理'),
                      leading: Icon(Icons.lock),
                      onPressed: (context) {
                        if(user!.isAdmin) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserViewPage(),
                            ),
                          );
                        }
                        else{
                          showDialog(
                              context: context,
                              builder: (BuildContext context) { return Text('没有权限访问！'); }
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
      ),
    );
  }
}