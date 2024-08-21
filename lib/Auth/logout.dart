import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/auth/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final AuthService _authService =
      SupabaseUserService(Supabase.instance.client);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログアウト'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _handleLogout,
          child: const Text('ログアウト'),
        ),
      ),
    );
  }

  // Supabaseを使用してログアウト処理
  Future<void> _handleLogout() async {
    try {
      await _authService.signOut();
      _navigateToLoginPage();
    } catch (e) {
      _showErrorDialog('ログアウトに失敗しました。');
    }
  }

  // ログインページに移動し、以前のすべてのルートを削除
  void _navigateToLoginPage() {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  // 与えられたメッセージとともにエラーダイアログを表示
  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('エラー'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
