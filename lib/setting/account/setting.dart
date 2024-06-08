import 'package:flutter/material.dart';
import 'package:rss_news/auth/logout.dart';

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
        children: const [
          ListTile(
            title: Text('アカウント情報'),
            onTap: null,
          ),
          ListTile(
            title: Text('ユーザー名変更'),
            onTap: null,
          ),
          ListTile(
            title: Text('メールアドレス変更'),
            onTap: null,
          ),
          ListTile(
            title: Text('パスワード変更'),
            onTap: null,
          ),
          // ログアウトボタン
          // logout.dart
          Logout(
            key: Key('logout'),
          ),
        ],
      ),
    );
  }
}
