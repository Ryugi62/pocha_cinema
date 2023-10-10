import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: LoginPage((isLoggedIn) {
      // 로그인 상태 업데이트 함수
      if (isLoggedIn) {
        // 로그인 성공한 경우
        print('로그인 성공');
      } else {
        // 로그인 실패 또는 로그아웃한 경우
        print('로그인 실패 또는 로그아웃');
      }
    }),
  ));
}

class LoginPage extends StatefulWidget {
  final Function(bool) updateLoginStatus; // 로그인 상태를 업데이트하는 함수를 받습니다.
  LoginPage(this.updateLoginStatus, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final url = Uri.parse('http://192.168.1.197:8000/api/login');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode(
      {
        'username': username,
        'pwd': password,
      },
    );

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // 로그인 성공한 경우
        widget.updateLoginStatus(true);

        print('response headers: ${response.headers}');
        print("cookie: ${response.headers['set-cookie']}");

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
    } catch (e) {
      // 요청 실패한 경우
      print('HTTP 요청 실패: $e');
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
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: '아이디',
                labelStyle: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onEditingComplete: () {
                // 아이디 입력 필드에서 엔터를 눌렀을 때 비밀번호 입력 필드로 이동
                FocusScope.of(context).nextFocus();
              },
              autofocus: true, // 아이디 입력 필드가 화면이 로드될 때 포커스를 받도록 설정
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
              onEditingComplete: () {
                // 비밀번호 입력 필드에서 엔터를 눌렀을 때 로그인 수행
                _login(context);
              },
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
