import 'package:flutter/material.dart';
import './views/home_page.dart';
import './views/404_page.dart';
import './views/admin/admin_page.dart';
import './views/admin/payment_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // 페이지 경로와 위젯을 연결하는 함수를 정의합니다.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Pocha Cinema 🍿'));
      case '/admin':
        return MaterialPageRoute(
            builder: (context) => AdminPage(title: "Admin Page"));
      case '/admin/payment':
        return MaterialPageRoute(
            builder: (context) => PaymentPage(
                  tableNumber: settings.arguments as int,
                ));
      default:
        return MaterialPageRoute(builder: (context) => NotFoundPage());
    }
  }

// Could not find a set of Noto fonts to display all missing characters. Please add a font asset for
// the missing characters. See: https://flutter.dev/docs/cookbook/design/fonts
  // 앱 테마 설정과 라우팅 설정을 별도의 함수로 분리합니다.
  MaterialApp _buildApp(BuildContext context) {
    return MaterialApp(
      title: 'Pocha Cinema',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'NotoSansKR', // 폰트 패밀리 설정
            color: Colors.white,
            fontSize: 16, // 원하는 폰트 크기 설정
          ),
          bodyText2: TextStyle(
            fontFamily: 'NotoSansKR', // 폰트 패밀리 설정
            color: Colors.white,
            fontSize: 14, // 원하는 폰트 크기 설정
          ),
          // 다른 텍스트 스타일들도 설정 가능
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: generateRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildApp(context);
  }
}
