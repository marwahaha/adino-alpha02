import 'package:flutter/material.dart';
import 'login_page.dart';
import 'authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adino',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: LoginPage(auth: new Auth()),
		);
  }
}

