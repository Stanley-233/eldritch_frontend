import 'dart:convert';

import 'package:eldritch_frontend/services/user_view_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../services/api_service.dart';
import '../widgets/group_view.dart';
import 'group_add_page.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListState();
}

class _GroupListState extends State<GroupListPage> {
  final Map<int, Color> colorMap = {
    1: Colors.green,
    2: Colors.blue,
    3: Colors.yellow,
    4: Colors.orange,
    5: Colors.purple,
    6: Colors.cyan,
    7: Colors.pink,
    8: Colors.brown,
    9: Colors.grey,
    10: Colors.teal,
    11: Colors.indigo,
    12: Colors.lime,
    13: Colors.amber,
    14: Colors.deepOrange,
    15: Colors.deepPurple,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户组列表'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Response>(
          // TODO
          future: getGroupList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(),
                  )
              );
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
                } else if (response.statusCode == 403) {
                  return Center(
                    child: Text('用户不属于任何组'),
                  );
                }
                return Center(
                  child: Text("服务器内部错误"),
                );
              }
              final groupList = extractGroupFromJson(utf8.decode(response.bodyBytes));
              if (groupList.isEmpty) {
                return Center(
                  child: Text('无用户组信息'),
                );
              }
              return Center(
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width > 800) ? 800 : MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.separated(
                    itemCount: groupList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String subtitle;
                      if (groupList[index].groupDescription.length < 30) {
                        subtitle = groupList[index].groupDescription;
                      } else {
                        subtitle = groupList[index].groupDescription.substring(0, 25);
                      }
                      return ListTile(
                        title: Text(groupList[index].groupName),
                        iconColor: colorMap[groupList[index].groupId % colorMap.length],
                        leading: Icon(Icons.group),
                        subtitle: Text(subtitle),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("确定删除该用户组吗？"),
                                  content: Text("警告：删除后将无法恢复该用户组及其下的所有用户"),
                                  actions: [
                                    TextButton(
                                      child: Text("取消"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text("删除"),
                                      onPressed: () async {
                                        // TODO
                                        final responseCode = await deleteGroup(groupList[index].groupId);
                                        Navigator.pop(context);
                                        if (responseCode == 200) {
                                          setState(() {
                                            groupList.removeAt(index); // 删除对应的 ListTile
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("成功删除用户组")),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("删除失败，请重试")),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          },
                        ),
                        onTap: () {
                          // TODO
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupView(
                                  group: groupList[index]),
                            ),
                          );
                        }
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => GroupAddPage()));
        },
        tooltip: "新增用户组",
        label: const Text("新建用户组"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
