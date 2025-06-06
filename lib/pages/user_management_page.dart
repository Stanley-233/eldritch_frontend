import 'dart:convert';

import 'package:eldritch_frontend/models/user_group.dart';
import 'package:eldritch_frontend/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/user.dart';

class UserManagementPage extends StatefulWidget {
  final User userNow;
  final List<UserGroup> groupList;
  final List<UserGroup> userGroups;
  UserManagementPage({super.key, required this.userNow, required this.groupList, required this.userGroups});
  @override
  State<UserManagementPage> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagementPage> {
  late List<bool?> isChecked;
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  void _loadData() {
    isChecked = List.filled(widget.groupList.length, false);
    for(int i = 0; i < widget.groupList.length; i++){
      for (int j = 0; j < widget.userGroups.length; j++){
        if(widget.groupList[i].groupId == widget.userGroups[j].groupId){
          isChecked[i] = true;
        }
      }
    }
  }

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
        child: Builder (
          builder: (context) {
              if (widget.groupList.isEmpty) {
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
                      return CheckboxListTile (
                        title: Text(widget.groupList[index].groupName),
                        value: isChecked[index],
                        onChanged: (bool? value) async {
                          if (value!) {
                            var code = await postAddGroup(widget.userNow.name, widget.groupList[index].groupId);
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
                            final code = await postRemoveFromGroup(widget.userNow.name, widget.groupList[index].groupId);
                            if (code == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('成功移出该组')));
                              setState(() {
                                isChecked[index] = value;
                              });
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
                    itemCount: widget.groupList.length)
                )
              );
            }
        ),
      )
    );
  }
}
