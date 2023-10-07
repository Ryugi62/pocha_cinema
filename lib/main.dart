import 'package:flutter/material.dart';
import './views/home_page.dart';
import './views/404_page.dart';
import './views/admin/admin_page.dart';
import './views/admin/payment_page.dart';
import './views/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  bool isLoggedIn = false; // 로그인 상태를 저장하는 변수

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
            : LoginPage(updateLoginStatus), // 로그인 상태에 따라 페이지를 다르게 표시
        '/admin/payment/:tableNumber': (context) {
          // '/admin/payment/:tableNumber' 경로로 이동하면 파라미터를 추출
          final Map<String, dynamic> params = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;

          print(params);

          return PaymentPage(
            tableNumber: int.parse(params['tableNumber']),
          );
        },
        '/404': (context) => NotFoundPage(),
      },
    );
  }
}
