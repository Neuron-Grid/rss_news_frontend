import 'package:flutter/material.dart';
import 'package:rss_news/setting/app/theme_mode_selection.dart';

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
            title: const Text('テーマ設定'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemeModeSelection(
                    onThemeModeChanged: (newThemeMode) {},
                  ),
                ),
              );
            },
          ),
          const ListTile(
            title: Text('プッシュ通知設定'),
            onTap: null,
          ),
          const ListTile(
            title: Text('バージョン情報'),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
