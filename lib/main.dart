// ./main.dart

import 'package:flutter/material.dart';
import './views/home_page.dart';
import './views/404_page.dart';
import './views/admin/admin_page.dart';
import './views/admin/payment_page.dart';
import './views/login_page.dart';
import './views/admin/order_page.dart';
import 'dart:html';

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
        '/': (context) {
          var uri = Uri.dataFromString(
              window.location.href); //converts string to a uri
          Map<String, String> params =
              uri.queryParameters; // query parameters automatically populated

          return MyHomePage(title: '포차시네마', table_id: params['tableId']);
        },
        // '/admin': (context) => isLoggedIn
        //     ? AdminPage(title: "관리자 페이지")
        //     : LoginPage(updateLoginStatus),
        // '/admin/payment/:tableNumber': (context) {
        //   final Map<String, dynamic> params = ModalRoute.of(context)!
        //       .settings
        //       .arguments as Map<String, dynamic>;

        //   return PaymentPage(
        //     tableNumber: int.parse(params['tableNumber']),
        //   );
        // },
        // '/admin/order': (context) => OrderPage(),

        // /admin 으로 시작하는 모든 경로는 로그인이 필요하다.
        '/admin': (context) => LoginPage(updateLoginStatus),
        '/admin/payment/:tableNumber': (context) {
          final Map<String, dynamic> params = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;

          return isLoggedIn
              ? PaymentPage(
                  tableNumber: int.parse(params['tableNumber']),
                )
              : LoginPage(updateLoginStatus);
        },
        '/admin/order': (context) =>
            isLoggedIn ? OrderPage() : LoginPage(updateLoginStatus),
        '/404': (context) => NotFoundPage(),
      },
    );
  }
}
