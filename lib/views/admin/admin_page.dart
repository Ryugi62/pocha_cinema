import 'package:flutter/material.dart';
import './payment_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'NotoSansKR', // Apply NotoSansKR font here
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                String buttonText = index != 4 ? 'B${index + 1}' : '마감';
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () => _showCurrentDate(context, index + 1),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontFamily: 'NotoSansKR', // Apply NotoSansKR font here
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 5),
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
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentPage(tableNumber: number),
                        ),
                      );
                    },
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontFamily: 'NotoSansKR', // Apply NotoSansKR font here
                      ),
                    ),
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
          title: Text(
            "번호 $number",
            style: TextStyle(
              fontFamily: 'NotoSansKR', // Apply NotoSansKR font here
            ),
          ),
          content: Text(
            "${now.year}-${now.month}-${now.day}",
            style: TextStyle(
              fontFamily: 'NotoSansKR', // Apply NotoSansKR font here
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "확인",
                style: TextStyle(
                  fontFamily: 'NotoSansKR', // Apply NotoSansKR font here
                ),
              ),
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
