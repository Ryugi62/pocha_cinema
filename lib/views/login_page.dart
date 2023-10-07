import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function(bool) updateLoginStatus; // 로그인 상태를 업데이트하는 함수를 받습니다.
  LoginPage(this.updateLoginStatus, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // 여기에서 username과 password를 확인하여 관리자 여부를 판단
    if (username == 'admin' && password == 'password') {
      // 관리자로 로그인 성공한 경우
      // 상태 업데이트 함수 호출
      widget.updateLoginStatus(true);
      Navigator.of(context).pushNamed('/admin'); // 관리자 페이지로 이동
    } else {
      // 로그인 실패한 경우
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('로그인 실패'),
          content: Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '술집 로그인',
          style: TextStyle(
            fontFamily: 'NotoSansKR',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent, // 앱바 배경 투명으로 설정
        elevation: 0, // 앱바 그림자 제거
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              style: TextStyle(color: Colors.white), // 텍스트 색상 설정
              decoration: InputDecoration(
                labelText: '아이디',
                labelStyle: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // 테두리 색상 설정
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              style: TextStyle(color: Colors.white), // 텍스트 색상 설정
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                labelStyle: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // 테두리 색상 설정
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // 버튼 배경색 설정
              ),
              child: Text(
                '로그인',
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.black, // 버튼 텍스트 색상 설정
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // 배경색 설정
    );
  }
}
