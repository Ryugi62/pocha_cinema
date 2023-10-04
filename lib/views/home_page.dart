import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final double price;
  final String imagePath;
  int quantity;

  MenuItem(this.name, this.price, this.imagePath, {this.quantity = 0});

  void addToCart() => quantity++;

  void removeFromCart() {
    if (quantity > 1) {
      quantity--;
    } else {
      quantity = 0;
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocha Cinema 🍿',
      theme: ThemeData(primarySwatch: Colors.blue),
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
    // 다른 음식 항목 추가
  ];

  final List<MenuItem> cart = [];
  bool isCartVisible = false;

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
    final existingItemIndex = cart.indexWhere((cartItem) =>
        cartItem.name == item.name && cartItem.imagePath == item.imagePath);

    if (existingItemIndex != -1) {
      cart[existingItemIndex].addToCart();
    } else {
      cart.add(MenuItem(item.name, item.price, item.imagePath, quantity: 1));
    }

    setState(() {});
  }

  void removeFromCart(MenuItem item) {
    final existingItem = findCartItem(item);

    if (existingItem != null) {
      existingItem.removeFromCart();
      if (existingItem.quantity == 0) {
        cart.remove(existingItem);
      }
    }

    setState(() {});
  }

  double calculateTotal() =>
      cart.fold(0, (total, item) => total + item.price * item.quantity);

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => addToCart(item),
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(
                            item.imagePath, // 이미지 경로는 런타임에 결정되므로 const 사용 불가
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.name, // 텍스트는 런타임에 결정되므로 const 사용 불가
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${item.price.toInt()} 원', // 텍스트는 런타임에 결정되므로 const 사용 불가
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
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
              color: Colors.white,
              child: ListView.builder(
                itemCount: cart.length > 3 ? 3 : cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return ListTile(
                    leading: Image.asset(
                        item.imagePath), // 이미지 경로는 런타임에 결정되므로 const 사용 불가
                    title: Text(item.name), // 텍스트는 런타임에 결정되므로 const 사용 불가
                    subtitle:
                        Text('${item.price.toInt()} 원 x ${item.quantity}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => removeFromCart(item),
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            '총 금액: ${calculateTotal().toInt()} 원',
            style: const TextStyle(fontSize: 24),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('주문 완료'),
                    content: Text('${calculateTotal().toInt()} 원 주문이 완료되었습니다.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            cart.clear();
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('주문하기', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}