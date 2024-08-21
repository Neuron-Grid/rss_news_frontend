import 'package:flutter/material.dart';
import 'package:rss_news/reader/preparing_screen.dart';

class AppSetting extends StatelessWidget {
  const AppSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アプリ設定'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('プッシュ通知設定'),
            // タップ時にPreparingScreenを表示する
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PreparingScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('バージョン情報'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PreparingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
