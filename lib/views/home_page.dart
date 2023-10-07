import 'package:flutter/material.dart';

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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
        textTheme: TextTheme(
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
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'ICE-POCHA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<MenuItem> menuItems = [
    MenuItem('피자', 15000, 'pizza.jpg'),
    MenuItem('햄버거', 10000, 'hamburger.jpg'),
    MenuItem('파스타', 12000, 'pasta.jpg'),
    // Add more menu items here
  ];

  final List<MenuItem> cart = [];
  bool isCartVisible = false;
  Color cardColor = Colors.white;

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
        actions: [
          IconButton(
            onPressed: toggleCartVisibility,
            icon: Icon(Icons.shopping_cart),
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
                  onTap: () {
                    setState(() {
                      cardColor = Colors.white;
                    });
                    addToCart(item);
                  },
                  child: Card(
                    elevation: cardColor == Colors.white ? 3 : 0,
                    color: cardColor,
                    child: InkWell(
                      splashColor: Colors.green,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
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
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${formatNumberWithCommas(item.price.toInt())} 원',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
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
                itemCount: cart.length > 3 ? 3 : cart.length,
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
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    subtitle: Text(
                      '${formatNumberWithCommas(item.price.toInt())} 원 x ${item.quantity}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => removeFromCart(item),
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            '총 금액: ${formattedTotal} 원',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontFamily: 'NotoSansKR',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
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
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
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
                      TextButton(
                        onPressed: () {
                          setState(() {
                            cart.clear();
                          });
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
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
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
