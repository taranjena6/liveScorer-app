import 'package:Score_Dekho/admin/admin_login.dart';
import 'package:Score_Dekho/user/MainUi.dart';
import 'package:Score_Dekho/user/match_page.dart';
import 'package:flutter/material.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Image.asset(
                  'assets/images/IMG-20210303-WA0001-removebg-preview.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: RaisedButton(
                      color: Color(0xFF009270),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AdminLogin();
                        }));
                      },
                      child: Text(
                        'Admin',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: RaisedButton(
                      color: Color(0xFF009270),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MainUI();
                        }));
                      },
                      child: Text(
                        'User',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 140.0,
            ),
            Text(
              'Made By Family For The Family  ',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '@ScoreDekho',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
