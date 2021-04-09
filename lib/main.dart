import 'package:Score_Dekho/admin/login.dart';
// import 'package:Score_Dekho/try.dart';
// import 'package:Score_Dekho/main_page.dart';
//import 'package:Score_Dekho/user/user_ui.dart';
//import 'package:Score_Dekho/user/usreui.dart';
// import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginUI(),
    );
  }
}
