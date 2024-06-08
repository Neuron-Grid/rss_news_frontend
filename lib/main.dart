import 'package:flutter/material.dart';
import 'package:rss_news/auth/login_page.dart';
import 'package:rss_news/auth/login_service.dart';
import 'package:rss_news/reader/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'RSS News',
      home: AuthCheckPage(),
    );
  }
}

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LoginService().isLoggedIn(),
      builder: (context, snapshot) {
        // ローディング中の表示
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // エラー発生時の表示
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error\n ${snapshot.error}')),
            );
          } else {
            // ログイン状態に応じた表示
            if (snapshot.hasData && snapshot.data == true) {
              return const MyHomePage();
            } else {
              return const LoginPage();
            }
          }
        }
      },
    );
  }
}
