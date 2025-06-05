import 'package:eldritch_frontend/pages/manage_page.dart';
import 'package:eldritch_frontend/pages/message_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _FunctionAreaState();
}

class _FunctionAreaState extends State<StatefulWidget> {
  final ValueNotifier<int> funID = ValueNotifier(0);
  final _switchPage = PageController();

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
        selectedIcon: Icon(Icons.notifications),
        icon: Icon(Icons.notifications_outlined),
        label: Text('反馈'),
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
                      child: Image.asset('assets/images/stupid_rabbit.jpg')),
                ))),
        destinations: destinations,
        selectedIndex: index,
        onDestinationSelected: (int indexSelected) {
          funID.value = indexSelected;
          _switchPage.jumpToPage(indexSelected);
        });
    }
    return Scaffold(
        body: Row(children: [
          ValueListenableBuilder<int>(
              valueListenable: funID,
              builder: (_, index, __) => buildLeftNavigation(index)),
          Expanded(
              child: PageView(
            controller: _switchPage,
            children: [
              MessageListPage(),
              Text('工单'),
              Text('反馈'),
              ManagePage(),
            ],
          ))
        ]));
  }

  @override
  void dispose(){
    super.dispose();
    _switchPage.dispose();
  }
}
