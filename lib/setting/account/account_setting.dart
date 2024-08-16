import 'package:flutter/material.dart';
import 'package:rss_news/auth/logout.dart';
import 'package:rss_news/setting/account/change_email.dart' as change_email;
import 'package:rss_news/setting/account/change_password.dart';
import 'package:rss_news/setting/account/change_username.dart';
import 'package:rss_news/setting/account/view_account.dart';

// アカウント設定画面
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
            title: const Text('ユーザー名変更'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangeUsernamePage()),
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
                    builder: (context) => const ChangePasswordPage()),
              );
            },
          ),
          const ListTile(
            title: Text('パスワードをリセット'),
          ),
          const Logout(
            key: Key('logout'),
          ),
        ],
      ),
    );
  }
}
