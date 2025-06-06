import 'dart:convert';

import 'package:eldritch_frontend/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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
  List<dynamic> groupList = [];
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

  List<bool> isChecked = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户管理'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PopScope(
        child: FutureBuilder<List<Response>>(
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
              final groupList = extractGroupsFromJson(
                  utf8.decode(groupListResponse.bodyBytes));
              final userGroups = extractGroupsFromJson(
                  utf8.decode(userGroupsResponse.bodyBytes));
              if (groupList.isEmpty) {
                return Center(
                  child: Text('暂无用户组'),
                );
              }
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 800 ? 800 : MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      isChecked[index] = false;
                      for(int i = 0; i < userGroups.length; i++){
                        if(groupList[index].groupId == userGroups[i].groupId){
                          isChecked[index] = true;
                        }
                      }
                      return CheckboxListTile (
                        title: Text(groupList[index].groupName),
                        value: isChecked[index],
                        onChanged: (bool? value) async {
                          if (value!) {
                            var code = await postAddGroup(widget.userNow.name, groupList[index].groupId);
                            if (code == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('成功加入该组')));
                              setState(() {
                                isChecked[index] = value;
                              });
                            } else if (code == 400) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('用户已在该组中')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('添加失败，请稍后再试')));
                            }
                          } else {
                            final code = await postRemoveFromGroup(widget.userNow.name, groupList[index].groupId);
                            if (code == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('成功移出该组')));

                            } else if (code == 400) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('用户已不在该组中')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('删除失败，请稍后再试')));
                            }
                          }
                        });
                    },
                    separatorBuilder:
                        (BuildContext context, int index) {
                      return Divider(
                        height: 2,
                        color: Colors.transparent,
                      );
                    },
                    itemCount: groupList.length)
                )
              );
            }
          }
        ),
      )
    );
  }
}
