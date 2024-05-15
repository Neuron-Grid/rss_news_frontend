import 'package:flutter/material.dart';
import 'package:rss_news/reader/dummy_screen.dart';
import 'package:rss_news/reader/left_column/setting.dart';
import 'package:rss_news/reader/left_column/acknowledgement.dart';

class LeftColumn extends StatelessWidget {
  const LeftColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('メニュー'),
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
