import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/auth/logout.dart';
import 'package:rss_news/reader/preparing_screen.dart';
import 'package:rss_news/setting/account/change_email.dart' as change_email;
import 'package:rss_news/setting/account/change_password.dart';
import 'package:rss_news/setting/account/view_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// アカウント設定画面のウィジェット
class AccountSetting extends StatelessWidget {
  const AccountSetting({super.key});

  // ページ遷移のための汎用メソッド
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント設定'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('アカウント情報'),
            onTap: () => _navigateToPage(context, const ViewAccountPage()),
          ),
          // メールアドレス変更ページ
          ListTile(
            title: const Text('メールアドレス変更'),
            onTap: () =>
                _navigateToPage(context, const change_email.ChangeEmailPage()),
          ),
          // パスワード変更ページ
          ListTile(
            title: const Text('パスワード変更'),
            onTap: () => _navigateToPage(
              context,
              ChangePasswordPage(
                  authService: SupabaseUserService(Supabase.instance.client)),
            ),
          ),
          // パスワードリセットの準備中ページ
          ListTile(
            title: const Text('パスワードをリセット'),
            onTap: () => _navigateToPage(context, const PreparingScreen()),
          ),
          // ログアウトボタン
          const Logout(
            key: Key('logout'),
          ),
        ],
      ),
    );
  }
}
