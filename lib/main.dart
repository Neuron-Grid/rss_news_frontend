import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/auth/login_page.dart';
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
        fontFamily: 'NotoSansMonoCJK',
      ),
      locale: const Locale('ja'),
      supportedLocales: const [
        Locale('ja'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const AuthCheckPage(),
    );
  }
}

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    final authService = SupabaseUserService(Supabase.instance.client);

    return FutureBuilder<User?>(
      future: Future.value(authService.getCurrentUser()),
      builder: (context, snapshot) {
        // ローディング中の表示
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // エラー発生時の表示
        if (snapshot.hasError) {
          logger.e('Error\n ${snapshot.error}');
          return const Scaffold(
            body: Center(child: Text('エラーが発生しました。')),
          );
        }

        // ログイン状態に応じた表示
        if (snapshot.hasData && snapshot.data != null) {
          logger.i("User is logged in: ${authService.getEmail(snapshot.data)}");
          return const MainPageApp();
        } else {
          logger.i("User is not logged in.");
          return const LoginPage();
        }
      },
    );
  }
}
