import 'package:flutter/material.dart';

class DummyScreen extends StatelessWidget {
  const DummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ダミー画面'),
      ),
      body: const Center(
        child: Text('これはダミー画面です'),
      ),
    );
  }
}
