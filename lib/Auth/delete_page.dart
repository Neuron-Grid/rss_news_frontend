import 'package:flutter/material.dart';
import 'package:rss_news/validator/url_opener.dart';

class DeletePage extends StatelessWidget {
  const DeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウントを削除'),
      ),
      body: Center(
        child: _buildContent(context),
      ),
    );
  }

  // テキストスタイルを関数化
  TextStyle _buildTextStyle() {
    return const TextStyle(fontSize: 18);
  }

  // URLオープン処理を関数化
  void _openDeleteAccountUrl(BuildContext context) {
    UrlOpener(context).openUrl('https://contact.neuron-grid.net/');
  }

  // コンテンツ全体を関数化
  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildWarningText(),
        const SizedBox(height: 20),
        _buildInstructionText(),
        const SizedBox(height: 10),
        _buildUrlLink(context),
      ],
    );
  }

  // 警告テキストを関数化
  Widget _buildWarningText() {
    return Text(
      '本当にアカウントを削除しますか？',
      style: _buildTextStyle(),
    );
  }

  // 説明テキストを関数化
  Widget _buildInstructionText() {
    return Text(
      'アカウントを削除する場合は以下のURLから連絡してください。',
      style: _buildTextStyle(),
      textAlign: TextAlign.center,
    );
  }

  // URLリンクを関数化
  Widget _buildUrlLink(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDeleteAccountUrl(context),
      child: const Text(
        'https://contact.neuron-grid.net/',
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
