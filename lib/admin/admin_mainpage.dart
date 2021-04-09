import 'package:Score_Dekho/admin/admin_match_fixture.dart';
import 'package:flutter/material.dart';

class AdminMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2545),
        title: Text("Admin panel"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminMatchFixture()));
                },
                child: Text("Match fixture")),
            FlatButton(onPressed: () {}, child: Text("Player managment"))
          ],
        ),
      ),
    );
  }
}
