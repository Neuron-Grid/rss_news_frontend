import 'package:flutter/material.dart';
import 'package:rss_news/Auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'RSS News',
      home: LoginPage(),
    );
  }
}
