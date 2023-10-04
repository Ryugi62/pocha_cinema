import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관리자 페이지'),
      ),
      // 관리자 페이지의 내용을 구성하세요.
      body: Center(
        child: Text('이곳은 관리자 페이지입니다.'),
      ),
    );
  }
}