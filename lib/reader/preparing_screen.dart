import 'package:flutter/material.dart';

class PreparingScreen extends StatelessWidget {
  const PreparingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('準備中'),
      ),
      body: const Center(
        child: Text(
          'この画面は現在準備中です',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
