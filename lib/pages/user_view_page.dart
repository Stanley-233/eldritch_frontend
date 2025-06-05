import 'dart:convert';

import 'package:eldritch_frontend/pages/user_management_page.dart';
import 'package:eldritch_frontend/services/user_view_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../services/auth_service.dart';

class UserViewPage extends StatefulWidget {
  const UserViewPage({super.key});

  @override
  State<UserViewPage> createState() => _UserViewState();
}

class _UserViewState extends State<UserViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户列表'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Response>(
          future: getUserList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
                ));
            } else if (snapshot.hasError) {
              return Center(
                child: Text('无法连接到服务器'),
              );
            } else {
              // 成功的
              final response = snapshot.data;
              if (response!.statusCode != 200) {
                if (response.statusCode == 404) {
                  return Center(
                    child: Text('用户不存在，请重新登录'),
                  );
                }
                return Center(
                  child: Text("服务器内部错误"),
                );
              }
              final userList = extractFromJson(utf8.decode(response.bodyBytes));
              return Center(
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width > 800) ? 800 : MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.separated(
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(userList[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserManagementPage(userNow: userList[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 2.0,
                        color: Colors.transparent,
                      );
                    }
                  )
                )
              );
            }
          }
        )
      ),
    );
  }
}
