import 'package:flutter/material.dart';

import '../models/order.dart';

class OrdersPageBase extends StatelessWidget {
  final Future<List<Order>> openOrders;
  final Future<List<Order>> rejectOrders;
  final Future<List<Order>> closedOrders;
  final String title;
  final Widget? floatingActionButton;
  final bool isEditable;

  const OrdersPageBase({
    super.key,
    required this.openOrders,
    required this.rejectOrders,
    required this.closedOrders,
    required this.title,
    this.floatingActionButton,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Flexible(
            child: OrderColumn(
              title: '---待处理---',
              ordersFuture: openOrders,
              isEditable: isEditable,
            )
          ),
          Flexible(
            child: OrderColumn(
              title: '---已批准---',
              ordersFuture: rejectOrders,
              isEditable: isEditable,
            )
          ),
          Flexible(
            child: OrderColumn(
              title: '---已拒绝---',
              ordersFuture: closedOrders,
              isEditable: isEditable
            ),
          )
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class OrderColumn extends StatelessWidget {
  final String title;
  final bool isEditable;
  final Future<List<Order>> ordersFuture;

  const OrderColumn({
    super.key,
    required this.title,
    required this.ordersFuture,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 1200
        ? 1200
        : MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width > 900
        ? 900 / 3 - 50
        : MediaQuery.of(context).size.height / 3 - 50,
      child: Column(
        children: [
          Text(title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey)),
          SizedBox(
            height: 10
          ),
          Flexible(
            child: FutureBuilder(
              future: ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('无法连接到服务器'),
                  );
                } else {
                  final orderList = snapshot.data;
                  if (orderList == null || orderList.isEmpty) {
                    return Center(
                      child: Text('暂无工单'),
                    );
                  }
                  return ListView.separated(
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      final temp = orderList[index].content.replaceAll('\n', ' ');
                      final preview = temp.length > 30
                          ? temp.substring(0, 30)
                          : temp;
                      return ListTile(
                        title: Text(orderList[index].title),
                        subtitle: Text(preview),
                        onTap: () {
                          // TODO
                          if (isEditable) {
                            // return;
                          } else {
                            // Navigator.pushNamed(
                            //   context,
                            //   '/order_detail',
                            //   arguments: orderList[index],
                            // );
                          }
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 1,
                        color: Colors.transparent,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}