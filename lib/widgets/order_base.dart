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
      body: Text("TODO"),
      floatingActionButton: floatingActionButton,
    );
  }
}
