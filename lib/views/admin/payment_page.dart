import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final int tableNumber;

  const PaymentPage({Key? key, required this.tableNumber}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final List<Map<String, dynamic>> orderedItems = [
    {'name': '아이스 커피', 'quantity': 2, 'price': 5000},
    {'name': '치즈케이크', 'quantity': 1, 'price': 7000},
    // Add other menu items
  ];

  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    calculateTotalAmount();
  }

  void calculateTotalAmount() {
    totalAmount = 0;
    for (var item in orderedItems) {
      totalAmount += (item['quantity'] as int) * (item['price'] as int);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '${widget.tableNumber}관 결제 페이지',
          style: TextStyle(
            fontFamily: 'NotoSansKR',
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '금액: ₩$totalAmount',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontFamily: 'NotoSansKR',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orderedItems.length,
              itemBuilder: (context, index) {
                final item = orderedItems[index];
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['name'] as String,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (item['quantity'] > 0) {
                                  item['quantity']--;
                                  calculateTotalAmount();
                                }
                              });
                            },
                            color: Colors.white,
                          ),
                          Text(
                            '${item['quantity']}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontFamily: 'NotoSansKR',
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                item['quantity']++;
                                calculateTotalAmount();
                              });
                            },
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        '입금을 확인하셨나요?',
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: Colors.black,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('no');
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('yes');
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ).then((value) {
                  if (value == 'yes') {
                    // Perform actions when "Yes" is selected
                  }
                });
              },
              child: Text(
                '결제 확인',
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'NotoSansKR',
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
