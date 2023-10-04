import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

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
        title: Text('결제 페이지'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '금액: ₩$totalAmount',
              style: TextStyle(fontSize: 24.0), // Increase the font size
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
                        style:
                            TextStyle(fontSize: 18.0), // Increase the font size
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
                          ),
                          Text('${item['quantity']}',
                              style: TextStyle(
                                  fontSize: 18.0)), // Increase the font size
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                item['quantity']++;
                                calculateTotalAmount();
                              });
                            },
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
                      title: Text('입금을 확인하셨나요?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('no');
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('yes');
                          },
                          child: Text('Yes'),
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
              child: Text('결제 확인'),
            ),
          ),
        ],
      ),
    );
  }
}