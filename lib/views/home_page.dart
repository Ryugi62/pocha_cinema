import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuItem {
  final String name;
  final double price;
  final String imagePath;
  int quantity;

  MenuItem(this.name, this.price, this.imagePath, {this.quantity = 0});

  void addToCart() {
    quantity++;
  }

  void removeFromCart() {
    if (quantity > 0) {
      quantity--;
    }
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocha Cinema 🍿',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'NotoSansKR',
            color: Colors.white,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            fontFamily: 'NotoSansKR',
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'ICE-POCHA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, this.table_id})
      : super(key: key);

  final String title;
  final String? table_id; // 추가된 table_id 변수

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 다음과 같이 table_id를 추가하고 초기화합니다.
  String? table_id;

  final List<MenuItem> menuItems = [
    MenuItem('콩불 中', 16000, 'Kong-bul-small.jpg'),
    MenuItem('콩불 大', 20000, 'Kong-bul-big.jpg'),
    MenuItem('대패숙주볶음', 17000, 'Spicy-pork-belly-stir-fry.jpg'),
    MenuItem('간장비빔국수', 10000, 'SoySauce-Bibim-Guksu.jpg'),
    MenuItem('삼겹비빔면', 10000, 'PorkBelly-Bibim-Noodles.jpg'),
    MenuItem('오뎅탕', 12000, 'FishcakeSoup.jpg'),
    MenuItem('소시지', 10000, 'sausage.jpeg'),
    MenuItem('감자콤보', 14000, 'potato-combo.jpeg'),
    MenuItem('물', 1000, 'water.jpeg'),
    MenuItem('콜라', 2000, 'pepsi.jpeg'),
    MenuItem('사이다', 2000, 'cider.jpeg'),
    MenuItem('직원 부르기', 0, 'people.jpg'),
    // Add more menu items here
  ];

  final List<MenuItem> cart = [];
  bool isCartVisible = false;

  double calculateTotal() {
    return cart.fold(0.0, (total, item) => total + item.price * item.quantity);
  }

  void toggleCartVisibility() {
    setState(() {
      isCartVisible = !isCartVisible;
    });
  }

  MenuItem? findCartItem(MenuItem item) {
    return cart.firstWhere(
      (cartItem) => cartItem.name == item.name,
      orElse: () => MenuItem('', 0.0, ''),
    );
  }

  void addToCart(MenuItem item) {
    final existingItem = findCartItem(item);

    if (existingItem?.name != '') {
      setState(() {
        existingItem?.addToCart();
      });
    } else {
      setState(() {
        final newItem =
            MenuItem(item.name, item.price, item.imagePath, quantity: 1);
        cart.add(newItem);
      });
    }
  }

  void removeFromCart(MenuItem item) {
    final existingItem = findCartItem(item);

    if (existingItem != null) {
      setState(() {
        existingItem.removeFromCart();
        if (existingItem.quantity == 0) {
          cart.remove(existingItem);
        }
      });
    }
  }

  String formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedTotal =
        formatNumberWithCommas(calculateTotal().toInt());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: toggleCartVisibility,
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];

                return GestureDetector(
                  child: Card(
                    elevation: 0, // No elevation when not selected
                    child: InkWell(
                      splashColor: Colors.black.withAlpha(50),
                      onTap: () {
                        addToCart(item);
                      },
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(3),
                                topRight: Radius.circular(3),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(item.imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${formatNumberWithCommas(item.price.toInt())} 원',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          AnimatedContainer(
            height: isCartVisible ? 400 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Card(
              color: Colors.black,
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(item.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: 60,
                      height: 60,
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    subtitle: Text(
                      '${formatNumberWithCommas(item.price.toInt())} 원 x ${item.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        removeFromCart(item);
                      },
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            '총 금액: ${formattedTotal} 원',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontFamily: 'NotoSansKR',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // 주문하기 버튼을 눌렀을 때 HTTP 요청을 보냄
              final url = Uri.parse(
                  'http://icepocha.vip:8000/api/inmarket/order?table_id=${widget.table_id}');

              final orderData = cart.map((item) {
                return {
                  // menu_id는 menu아이템의 index + 1를 보내고싶어.
                  // item.name과 일치하는 menuItems의 index를 찾아서 + 1을 해줘야함.
                  'menu_id': menuItems
                          .indexWhere((element) => element.name == item.name) +
                      1,
                  'quantity': item.quantity,
                };
              }).toList();

              // orderData 배열로 감싸기
              http
                  .post(url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'order_items': orderData,
                      }))
                  .then((response) {
                if (response.statusCode == 202) {
                  // 성공적으로 주문이 완료된 경우
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          '주문 완료',
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: Colors.black,
                          ),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${formattedTotal}원 주문이 완료되었습니다.',
                              style: const TextStyle(
                                fontFamily: 'NotoSansKR',
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              '(잘못된 주문은 카운터에 문의 바랍니다.)',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              // 취소 버튼을 눌렀을 때 수행할 동작
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              '취소',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black87,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                cart.clear();
                                isCartVisible = false;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              '확인',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black87,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // 주문에 실패한 경우
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          '주문 실패',
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: Colors.black,
                          ),
                        ),
                        content: Text(
                          '주문을 처리하는 동안 오류가 발생했습니다.',
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: Colors.black,
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '확인',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black87,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            },
            child: const Text(
              '주문하기',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'NotoSansKR',
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black87,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
