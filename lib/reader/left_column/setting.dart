import 'package:flutter/material.dart';
import 'package:rss_news/auth/login_page.dart';
import 'package:rss_news/auth/login_service.dart';
import 'package:rss_news/reader/dummy_screen.dart';
import 'package:rss_news/setting/account/setting.dart';
import 'package:rss_news/setting/app/app_setting.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
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
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DummyScreen()),
                );
              }
            },
          ),
          ListTile(
            title: const Text('表示設定'),
            onTap: () {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DummyScreen()),
                );
              }
            },
          ),
          ListTile(
            title: const Text('アカウント設定'),
            onTap: () {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AccountSetting()),
                );
              }
            },
          ),
          ListTile(
            title: const Text('アプリ設定'),
            onTap: () {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AppSetting()),
                );
              }
            },
          ),
          ListTile(
            title: const Text('ログアウト'),
            onTap: () async {
              final loginService = LoginService();
              await loginService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
