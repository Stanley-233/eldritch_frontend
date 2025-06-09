// dart
import 'package:flutter/material.dart';

import '../models/order.dart';
import '../widgets/order_base.dart';

class OrderAssignedListPage extends StatelessWidget {
  final Future<List<Order>> openOrders;
  final Future<List<Order>> rejectOrders;
  final Future<List<Order>> closedOrders;

  const OrderAssignedListPage({
    super.key,
    required this.openOrders,
    required this.rejectOrders,
    required this.closedOrders,
  });

  @override
  Widget build(BuildContext context) {
    return OrdersPageBase(
      openOrders: openOrders,
      rejectOrders: rejectOrders,
      closedOrders: closedOrders,
      isEditable: true,
      title: '待处理列表'
    );
  }
}