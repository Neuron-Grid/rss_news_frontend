import 'package:flutter/material.dart';
import 'package:rss_news/reader/dummy_screen.dart';

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
          ListTile(
            title: const Text('謝辞'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DummyScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('利用規約'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DummyScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('プライバシーポリシー'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DummyScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
