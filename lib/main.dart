// ./main.dart

import 'package:flutter/material.dart';
import './views/home_page.dart';
import './views/404_page.dart';
import './views/admin/admin_page.dart';
import './views/admin/payment_page.dart';
import './views/login_page.dart';
import './views/admin/order_page.dart';

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
        '/admin/order': (context) => OrderPage(),
        '/404': (context) => NotFoundPage(),
      },
    );
  }
}
