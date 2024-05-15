import 'package:flutter/material.dart';
import 'package:rss_news/reader/dummy_screen.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('RSSフィード設定'),
            onTap: () {
              // RSSフィード設定画面に遷移
              // ダミー画面に遷移
              const DummyScreen();
            },
          ),
          ListTile(
            title: const Text('表示設定'),
            onTap: () {
              // 表示設定画面に遷移
              // ダミー画面に遷移
              const DummyScreen();
            },
          ),
          ListTile(
            title: const Text('アカウント設定'),
            onTap: () {
              // アカウント設定画面に遷移
              // ダミー画面に遷移
              const DummyScreen();
            },
          ),
          ListTile(
            title: const Text('アプリ設定'),
            onTap: () {
              // アプリ設定画面に遷移
              // ダミー画面に遷移
              const DummyScreen();
            },
          ),
        ],
      ),
    );
  }
}
