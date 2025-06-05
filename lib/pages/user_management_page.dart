import 'dart:convert';

import 'package:card_settings_ui/card_settings_ui.dart';
import 'package:eldritch_frontend/services/api_service.dart';
import 'package:eldritch_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserManagementPage extends StatefulWidget {
  final User userNow;
  const UserManagementPage({super.key, required this.userNow});
  @override
  State<UserManagementPage> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagementPage> {
  // 存储两个Future的引用
  late Future<http.Response> _groupListFuture;
  late Future<http.Response> _userGroupsFuture;

  // 存储解析后的数据（可选）
  List<dynamic>  groupList = [];
  List<dynamic> userGroups = [];


  @override
  void initState() {
    super.initState();
    // 初始化加载数据
    _loadData();
  }

  void _loadData() {
    setState(() {
      _groupListFuture = getGroupList();
      _userGroupsFuture = getUserGroups(widget.userNow.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Scaffold(
      body: FutureBuilder<List<Response>>(
          future: Future.wait([_groupListFuture, _userGroupsFuture]),
          builder: (context, AsyncSnapshot<List<Response>> snapshot) {
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
              final groupListResponse = snapshot.data?[0] as http.Response;
              final userGroupsResponse = snapshot.data?[1] as http.Response;
              if (groupListResponse.statusCode != 200) {
                if (groupListResponse.statusCode == 404) {
                  return Center(
                    child: Text('用户不存在，请重新登录'),
                  );
                } else if (groupListResponse.statusCode == 403) {
                  return Center(
                    child: Text('用户不属于任何组'),
                  );
                }
                return Center(
                  child: Text("服务器内部错误"),
                );
              }
              final groupList =
                  extractGroupsFromJson(utf8.decode(groupListResponse.bodyBytes));
              final userGroups =
                  extractGroupsFromJson(utf8.decode(userGroupsResponse.bodyBytes));
              if (groupList.isEmpty) {
                return Center(
                  child: Text('暂无用户组'),
                );
              }
              return Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.separated(
                          itemBuilder: (BuildContext context, int index){
                            bool checked = userGroups.contains(groupList[index]);
                            return CheckboxListTile(
                              title: Text(groupList[index].groupName),
                              value: checked,
                              onChanged: (bool? value){
                                if(value!){
                                  postAddGroup(widget.userNow.name, groupList[index].groupId);
                                }
                                else{
                                  postRemoveFromGroup(widget.userNow.name, groupList[index].groupId);
                                }
                              }
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 0,
                              thickness: 10,
                              color: Colors.grey,
                              indent: 20,
                              endIndent: 20,
                            );
                          },
                          itemCount: groupList.length)
                  )
              );
            }
          }),
    ));
  }
}
