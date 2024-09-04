import 'package:flutter/material.dart';

class DeletePage extends StatelessWidget {
  const DeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウントを削除'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '本当にアカウントを削除しますか？',
              style: _textStyle,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteAccount,
              child: const Text('削除'),
            ),
          ],
        ),
      ),
    );
  }

  // 削除処理のメソッド
  void _deleteAccount() {
    // TODO: アカウント削除ロジックの実装
  }

  static const TextStyle _textStyle = TextStyle(fontSize: 18);
}
