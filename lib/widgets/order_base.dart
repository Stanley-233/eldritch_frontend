import 'package:eldritch_frontend/pages/orders_report_page.dart';
import 'package:eldritch_frontend/widgets/order_view.dart';
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
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Flexible(
              child: OrderColumn(
                title: '待处理',
                ordersFuture: openOrders,
                isEditable: isEditable,
              )
            ),
            SizedBox(height: 20),
            Flexible(
              child: OrderColumn(
                title: '已批准',
                ordersFuture: closedOrders,
                isEditable: isEditable,
              )
            ),
            SizedBox(height: 20),
            Flexible(
              child: OrderColumn(
                title: '已驳回',
                ordersFuture: rejectOrders,
                isEditable: isEditable
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
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
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer, // 背景颜色
        borderRadius: BorderRadius.circular(12.0), // 圆角
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // 阴影偏移
          ),
        ],
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 1000 ? 1000 : MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.width > 900 ? 900 / 3 - 50 : MediaQuery.of(context).size.height / 3 - 50,
        child: Column(
          children: [
            SizedBox(height: 5),
            Text(title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
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
                    if (orderList == null) {
                      return Center(
                        child: Text('返回为空'),
                      );
                    }
                    if (orderList.isEmpty) {
                      return Center(
                        child: Text('暂无此类工单'),
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
                            if (isEditable) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderReportPage(order: orderList[index]),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderView(order: orderList[index]),
                                ),
                              );
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
      ),
    );
  }
}