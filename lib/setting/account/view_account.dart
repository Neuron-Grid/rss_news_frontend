import 'package:flutter/material.dart';

class ViewAccountPage extends StatelessWidget {
  const ViewAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント情報'),
      ),
      body: const Center(
        child: Text('Display account information here'),
      ),
    );
  }
}
