import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/auth/logout.dart';
import 'package:rss_news/reader/preparing_screen.dart';
import 'package:rss_news/setting/account/change_email.dart' as change_email;
import 'package:rss_news/setting/account/change_password.dart';
import 'package:rss_news/setting/account/view_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountSetting extends StatelessWidget {
  const AccountSetting({super.key});

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewAccountPage()),
              );
            },
          ),
          ListTile(
            title: const Text('メールアドレス変更'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const change_email.ChangeEmailPage()),
              );
            },
          ),
          ListTile(
            title: const Text('パスワード変更'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(
                        authService:
                            SupabaseUserService(Supabase.instance.client))),
              );
            },
          ),
          ListTile(
            title: const Text('パスワードをリセット'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PreparingScreen()),
              );
            },
          ),
          const Logout(
            key: Key('logout'),
          ),
        ],
      ),
    );
  }
}
