import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 분홍색 버튼 5개
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                String buttonText =
                    index != 4 ? 'B${index + 1}' : '마감'; // B5의 이름을 "마감"으로 변경
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 243, 188, 206),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () {},
                  child: Text(buttonText),
                );
              }),
            ),
            SizedBox(height: 5),
            // 1~18까지의 버튼을 6x3 그리드 형태로 배치
            for (var i = 0; i < 3; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  int number = i * 6 + index + 1;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    onPressed: () => _showCurrentDate(context, number),
                    child: Text('$number'),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }

  void _showCurrentDate(BuildContext context, int number) {
    DateTime now = DateTime.now();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("번호 $number"),
          content: Text("${now.year}-${now.month}-${now.day}"),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
