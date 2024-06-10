import 'package:flutter/material.dart';
import 'package:rss_news/auth/login_page.dart';
import 'package:rss_news/auth/login_service.dart';
import 'package:rss_news/reader/dummy_screen.dart';
import 'package:rss_news/setting/account/setting.dart';
import 'package:rss_news/setting/app/app_setting.dart';

// 設定画面ウィジェット
class Setting extends StatefulWidget {
  const Setting({super.key});
  @override
  SettingState createState() => SettingState();
}

// 設定画面のステート
class SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          _buildListTile(
            title: 'RSSフィード設定',
            destination: const DummyScreen(),
          ),
          _buildListTile(
            title: '表示設定',
            destination: const DummyScreen(),
          ),
          _buildListTile(
            title: 'アカウント設定',
            destination: const AccountSetting(),
          ),
          _buildListTile(
            title: 'アプリ設定',
            destination: const AppSetting(),
          ),
          _buildLogoutTile(),
        ],
      ),
    );
  }

  // リストタイルを作成するヘルパーメソッド
  Widget _buildListTile({required String title, required Widget destination}) {
    return ListTile(
      title: Text(title),
      onTap: () {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
    );
  }

  // ログアウトのリストタイルを作成するヘルパーメソッド
  Widget _buildLogoutTile() {
    return ListTile(
      title: const Text('ログアウト'),
      onTap: () async {
        final loginService = LoginService();
        await loginService.logout();
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      },
    );
  }
}
