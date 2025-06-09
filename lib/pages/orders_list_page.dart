// dart
import 'package:flutter/material.dart';

import '../models/order.dart';
import '../widgets/order_base.dart';

class OrderListPage extends StatelessWidget {
  final Future<List<Order>> openOrders;
  final Future<List<Order>> rejectOrders;
  final Future<List<Order>> closedOrders;

  const OrderListPage({
    Key? key,
    required this.openOrders,
    required this.rejectOrders,
    required this.closedOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrdersPageBase(
      openOrders: openOrders,
      rejectOrders: rejectOrders,
      closedOrders: closedOrders,
      title: '订单列表',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 按钮事件
        },
        child: Icon(Icons.add),
      ),
    );
  }
}