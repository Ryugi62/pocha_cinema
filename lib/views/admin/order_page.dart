// ./views/admin/order_page.dart

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OrderPage(),
    );
  }
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Map<String, dynamic>> orders = [];

  void _addOrder(Map<String, dynamic> order) {
    setState(() {
      orders.add(order); // 새로운 주문을 리스트의 맨 뒤에 추가
    });
  }

  void _showCompleteOrderConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('주문 완료 여부', style: TextStyle(fontFamily: 'NotoSansKR')),
          content: Text('모든 주문이 완료되었습니까?',
              style: TextStyle(fontFamily: 'NotoSansKR')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No를 눌렀을 때
              },
              child: Text('No', style: TextStyle(fontFamily: 'NotoSansKR')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes를 눌렀을 때
              },
              child: Text('Yes', style: TextStyle(fontFamily: 'NotoSansKR')),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed) {
        setState(() {
          orders.removeAt(index); // 주문 삭제
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page', style: TextStyle(fontFamily: 'NotoSansKR')),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          final orderGroup = orders[index];
          final tableNumber = orderGroup['tableNumber'];
          final ordersList = orderGroup['orders'];
          bool isCompleted = true;
          for (final order in ordersList) {
            if (order[0] == false) {
              isCompleted = false;
              break;
            }
          }
          return Card(
            elevation: 8.0, // 그림자 효과
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
              side: BorderSide(color: Colors.grey[400]!), // 회색 경계선
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // 주문 완료 여부 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Table $tableNumber 주문 완료 여부',
                              style: TextStyle(fontFamily: 'NotoSansKR')),
                          content: Text('모든 주문이 완료되었습니까?',
                              style: TextStyle(fontFamily: 'NotoSansKR')),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); // No를 눌렀을 때
                              },
                              child: Text('No',
                                  style: TextStyle(fontFamily: 'NotoSansKR')),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // Yes를 눌렀을 때
                              },
                              child: Text('Yes',
                                  style: TextStyle(fontFamily: 'NotoSansKR')),
                            ),
                          ],
                        );
                      },
                    ).then((confirmed) {
                      if (confirmed) {
                        setState(() {
                          // 해당 테이블의 주문을 삭제
                          orders.removeAt(index);
                        });
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    color: Colors.blue,
                    child: Text(
                      '$tableNumber Table',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansKR', // NotoSansKR 글꼴 적용
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: ordersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final order = ordersList[index];
                      return ListTile(
                        onTap: () {
                          // 체크박스 값 변경
                          setState(() {
                            order[0] = !order[0];
                          });
                        },
                        leading: Checkbox(
                          value: order[0],
                          onChanged: (value) {
                            // 체크박스 값 변경
                            setState(() {
                              order[0] = value;
                            });
                          },
                        ),
                        title: Text(
                          order[1],
                          style: TextStyle(
                            color: order[0] ? Colors.grey : Colors.black,
                            fontSize: 16.0,
                            decoration:
                                order[0] ? TextDecoration.lineThrough : null,
                            fontFamily: 'NotoSansKR', // NotoSansKR 글꼴 적용
                          ),
                        ),
                        trailing: Text(
                          order[2],
                          style: TextStyle(
                            color: order[0] ? Colors.grey : Colors.black,
                            fontSize: 16.0,
                            decoration:
                                order[0] ? TextDecoration.lineThrough : null,
                            fontFamily: 'NotoSansKR', // NotoSansKR 글꼴 적용
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _addOrder({
      //       'tableNumber': orders.length + 1,
      //       'orders': [
      //         [false, '음식1', '2 개'],
      //         [false, '음식2', '1 개'],
      //         [false, '음식3', '5 개']
      //       ],
      //     });
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
