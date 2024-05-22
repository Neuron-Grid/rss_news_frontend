import 'package:flutter/material.dart';

// アプリ設定画面
class AppSetting extends StatelessWidget {
  const AppSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アプリ設定'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('テーマ設定'),
            onTap: null,
          ),
          ListTile(
            title: Text('言語設定'),
            onTap: null,
          ),
          ListTile(
            title: Text('プッシュ通知設定'),
            onTap: null,
          ),
          ListTile(
            title: Text('バージョン情報'),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
