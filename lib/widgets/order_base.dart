import 'package:flutter/material.dart';

import '../models/order.dart';

class OrdersPageBase extends StatelessWidget {
  final Future<List<Order>> openOrders;
  final Future<List<Order>> rejectOrders;
  final Future<List<Order>> closedOrders;
  final String title;
  final Widget? floatingActionButton;

  const OrdersPageBase({
    super.key,
    required this.openOrders,
    required this.rejectOrders,
    required this.closedOrders,
    required this.title,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SizedBox(
        width: (MediaQuery.of(context).size.width > 1200)
            ? 1200
            : MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height > 900)
            ? 900
            : MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Column(
              children: [
                Text('待处理'),
                FutureBuilder(
                    future: openOrders,
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
                        final openOrderList = snapshot.data;
                        return ListView.separated(
                          itemCount: openOrderList!.length,
                          itemBuilder: (context, index){
                            final temp = openOrderList[index].content.replaceAll('\n', ' ');
                            final preview = temp.length > 30
                                ? temp.substring(0, 30) : temp;
                            return ListTile(
                              title: Text(openOrderList[index].title),
                              subtitle: Text(preview),
                              onTap: (){
                                //Todo
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 2.0,
                              color: Colors.transparent,
                            );
                          },
                        );
                      }
                    }
                )
              ],
            ),
            Column(
              children: [
                Text('已批准'),
                FutureBuilder(
                    future: rejectOrders,
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
                        final rejectOrderList = snapshot.data;
                        return ListView.separated(
                          itemCount: rejectOrderList!.length,
                          itemBuilder: (context, index){
                            final temp = rejectOrderList[index].content.replaceAll('\n', ' ');
                            final preview = temp.length > 30
                                ? temp.substring(0, 30) : temp;
                            return ListTile(
                              title: Text(rejectOrderList[index].title),
                              subtitle: Text(preview),
                              onTap: (){
                                //Todo
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 2.0,
                              color: Colors.transparent,
                            );
                          },
                        );
                      }
                    }
                )
              ],
            ),
            Column(
              children: [
                Text('已拒绝'),
                FutureBuilder(
                    future: closedOrders,
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
                        final closedOrderList = snapshot.data;
                        return ListView.separated(
                          itemCount: closedOrderList!.length,
                          itemBuilder: (context, index){
                            final temp = closedOrderList[index].content.replaceAll('\n', ' ');
                            final preview = temp.length > 30
                                ? temp.substring(0, 30) : temp;
                            return ListTile(
                              title: Text(closedOrderList[index].title),
                              subtitle: Text(preview),
                              onTap: (){
                                //Todo
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 2.0,
                              color: Colors.transparent,
                            );
                          },
                        );
                      }
                    }
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
