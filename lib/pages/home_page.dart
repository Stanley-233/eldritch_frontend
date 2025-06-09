import 'dart:async';

import 'package:eldritch_frontend/pages/manage_page.dart';
import 'package:eldritch_frontend/pages/message_list_page.dart';
import 'package:eldritch_frontend/pages/order_assigned_list_page.dart';
import 'package:eldritch_frontend/pages/orders_list_page.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _FunctionAreaState();
}

class _FunctionAreaState extends State<HomePage> {
  final ValueNotifier<int> funID = ValueNotifier(0);
  final _switchPage = PageController();
  late Timer _timer;

  late OrderListPage _orderListPage;
  late OrderAssignedListPage _orderAssignedListPage;

  @override
  void initState() {
    super.initState();
    _updatePages();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _updatePages();
      });
    });
  }

  void _updatePages() {
    _orderListPage = OrderListPage(
      openOrders: getCreateUserOrders("open"),
      rejectOrders: getCreateUserOrders("reject"),
      closedOrders: getCreateUserOrders("closed"),
    );
    _orderAssignedListPage = OrderAssignedListPage(
      openOrders: getAssignedUserOrders("open"),
      rejectOrders: getAssignedUserOrders("reject"),
      closedOrders: getAssignedUserOrders("closed"),
    );
  }

  @override
  Widget build(BuildContext context) {
    const destinations = [
      NavigationRailDestination(
        selectedIcon: Icon(Icons.mail),
        icon: Icon(Icons.mail_outlined),
        label: Text('消息'),
      ),
      NavigationRailDestination(
        selectedIcon: Icon(Icons.commit),
        icon: Icon(Icons.commit_outlined),
        label: Text('工单'),
      ),
      NavigationRailDestination(
        selectedIcon: Icon(Icons.text_snippet),
        icon: Icon(Icons.text_snippet_outlined),
        label: Text('待处理'),
      ),
      NavigationRailDestination(
        selectedIcon: Icon(Icons.manage_accounts),
        icon: Icon(Icons.manage_accounts_outlined),
        label: Text('管理'),
      ),
    ];

    Widget buildLeftNavigation(int index) {
      return NavigationRail(
        groupAlignment: 1.0,
        labelType: NavigationRailLabelType.selected,
        leading: SizedBox(
          width: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ClipOval(
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  //待开发
                },
                child: Image.asset('assets/images/logo_rect.png'),
              ),
            ),
          ),
        ),
        destinations: destinations,
        selectedIndex: index,
        onDestinationSelected: (int indexSelected) {
          funID.value = indexSelected;
          _switchPage.jumpToPage(indexSelected);
        },
      );
    }

    return Scaffold(
      body: Row(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: funID,
            builder: (_, index, __) => buildLeftNavigation(index),
          ),
          Expanded(
            child: PageView(
              controller: _switchPage,
              children: [
                MessageListPage(),
                _orderListPage,
                _orderAssignedListPage,
                ManagePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _switchPage.dispose();
    super.dispose();
  }
}
