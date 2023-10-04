import 'package:flutter/material.dart';
import './views/home_page.dart';
import './views/404_page.dart';
import './views/admin/admin_page.dart';
import './views/admin/payment_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocha Cinema',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        // 페이지 라우팅을 설정
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/admin':
            return MaterialPageRoute(builder: (context) => const AdminPage());
          case '/admin/payment':
            return MaterialPageRoute(builder: (context) => const PaymentPage());
          default:
            return MaterialPageRoute(builder: (context) => NotFoundPage());
        }
      },
    );
  }
}