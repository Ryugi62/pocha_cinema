import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '새로운 주문 확인',
          style: TextStyle(
            fontFamily: 'NotoSansKR',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white, // AppBar 배경색 변경
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '새로운 주문 내역',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // 여기에 주문 내역을 표시하는 UI를 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
