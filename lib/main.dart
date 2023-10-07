import 'package:flutter/material.dart';
import './views/home_page.dart';
import './views/404_page.dart';
import './views/admin/admin_page.dart';
import './views/admin/payment_page.dart';
import './views/login_page.dart';
import './views/order_page.dart'; // order_page.dart 파일을 import

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  bool isLoggedIn = false;

  void updateLoginStatus(bool status) {
    isLoggedIn = status;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocha Cinema',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
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
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Pocha Cinema 🍿'),
        '/admin': (context) => isLoggedIn
            ? AdminPage(title: "관리자 페이지")
            : LoginPage(updateLoginStatus),
        '/admin/payment/:tableNumber': (context) {
          final Map<String, dynamic> params = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;

          return PaymentPage(
            tableNumber: int.parse(params['tableNumber']),
          );
        },
        '/order': (context) => OrderPage(), // 새로운 페이지를 라우트에 추가
        '/404': (context) => NotFoundPage(),
      },
    );
  }
}

// 나머지 코드는 유지됩니다.
