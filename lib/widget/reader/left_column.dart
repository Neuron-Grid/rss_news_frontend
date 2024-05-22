import 'package:flutter/material.dart';
import 'package:rss_news/reader/dummy_screen.dart';
import 'package:rss_news/reader/left_column/acknowledgement.dart';
import 'package:rss_news/reader/left_column/setting.dart';

class LeftColumn extends StatelessWidget {
  const LeftColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'メニュー',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset(
                  '/assets/images/1500x500.png',
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          _buildListTile(context, Icons.settings, '設定', const Setting()),
          _buildListTile(context, Icons.info, '謝辞', const Acknowledgement()),
          _buildListTile(
              context, Icons.description, '利用規約', const DummyScreen()),
          _buildListTile(
              context, Icons.privacy_tip, 'プライバシーポリシー', const DummyScreen()),
        ],
      ),
    );
  }

  ListTile _buildListTile(
      BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
