import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rss_news/auth/login_page.dart';
import 'package:rss_news/auth/login_service.dart';
import 'package:rss_news/reader/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sourceHanCodeJPTextTheme = Theme.of(context).textTheme.apply(
          fontFamily: 'Source Han Code JP',
        );

    final darkSourceHanCodeJPTextTheme = ThemeData.dark().textTheme.apply(
          fontFamily: 'Source Han Code JP',
        );

    return MaterialApp(
      title: 'RSS News',
      theme: ThemeData(
        textTheme: sourceHanCodeJPTextTheme,
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: darkSourceHanCodeJPTextTheme,
      ),
      themeMode: ThemeMode.system,
      home: const AuthCheckPage(),
    );
  }
}

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();

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
            // エラーをログに記録
            logger.e('Error\n ${snapshot.error}');
            return const Scaffold(
              body: Center(child: Text('エラーが発生しました。')),
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
