import 'package:Score_Dekho/admin/admin_mainpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Container(
                height: 200,
                child: Image.asset(
                    'assets/images/IMG-20210303-WA0001-removebg-preview.png'),
              ),
              SizedBox(
                height: 60.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.0, right: 12.0),
                child: TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  // obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'EMAIL',
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.0, right: 12.0),
                child: TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  // obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'PASSWAORD',
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Color(0xFF009270),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 40.0, color: Colors.white),
                ),
                onPressed: () async {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminMainPage()));
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
