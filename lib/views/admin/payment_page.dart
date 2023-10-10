import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  //   final List<MenuItem> menuItems = [
  //   MenuItem('콩불 中', 16000, 'Kong-bul-small.jpg'),
  //   MenuItem('콩불 大', 20000, 'Kong-bul-big.jpg'),
  //   MenuItem('대패숙주볶음', 17000, 'Spicy-pork-belly-stir-fry.jpg'),
  //   MenuItem('간장비빔국수', 10000, 'SoySauce-Bibim-Guksu.jpg'),
  //   MenuItem('삼겹비빔면', 10000, 'PorkBelly-Bibim-Noodles.jpg'),
  //   MenuItem('오뎅탕', 12000, 'FishcakeSoup.jpg'),
  //   MenuItem('소시지', 10000, 'sausage.jpeg'),
  //   MenuItem('감자콤보', 14000, 'potato-combo.jpeg'),
  //   MenuItem('물', 1000, 'water.jpeg'),
  //   MenuItem('콜라', 2000, 'pepsi.jpeg'),
  //   MenuItem('사이다', 2000, 'cider.jpeg'),
  //   MenuItem('직원 부르기', 0, 'people.jpg'),
  //   // Add more menu items here
  // ];

  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    calculateTotalAmount();

    // 페이지 렌더링 중에 요청 보내기
    sendRequest();
  }

  void calculateTotalAmount() {
    totalAmount = 0;
    for (var item in orderedItems) {
      totalAmount += (item['quantity'] as int) * (item['price'] as int);
    }
  }

  // 페이지 렌더링 중에 요청을 보내는 함수
  void sendRequest() async {
    final tableId = widget.tableNumber;
    final url =
        Uri.parse('http://icepocha.vip:8000/api/admin/show?table_id=$tableId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 요청이 성공한 경우, 응답을 처리할 수 있습니다.
        print('요청 성공! 응답 데이터: ${response.body}');
      } else {
        // 요청이 실패한 경우, 에러 처리를 수행할 수 있습니다.
        print('요청 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리를 수행할 수 있습니다.
      print('요청 중 예외 발생: $e');
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
          ElevatedButton(
            onPressed: () {
              // 이 버튼을 누르면 주문 변경 화면으로 이동하도록 코드를 추가하세요.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderChangePage()));
            },
            child: Text(
              '주문 변경',
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
