import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:rss_news/auth/login_page.dart';
import 'package:rss_news/auth/login_service.dart';
import 'package:rss_news/reader/main_page.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSS News',
      theme: ThemeData(
        fontFamily: 'SourceHanCodeJP',
      ),
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
