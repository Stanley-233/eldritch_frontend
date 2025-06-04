import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_settings_ui/card_settings_ui.dart';

import '../services/auth_service.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<StatefulWidget> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
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
                      leading: Icon(Icons.lock),
                      onPressed: (context) {
                        // Navigator.pushNamed(context, '/settings/create_user_group');
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
                        // Navigator.pushNamed(context, '/settings/info');
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