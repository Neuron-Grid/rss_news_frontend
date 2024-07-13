import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlOpener {
  final BuildContext context;
  final Logger logger = Logger();

  UrlOpener(this.context);

  Future<void> openUrl(String url) async {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      _showSnackBar('無効なURLです。');
      logger.w('無効なURLです: $url');
      return;
    }

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        // フォールバックオプションをここに追加
        _showSnackBar('URLを開けませんでした。デフォルトブラウザで開いてください。');
      }
    } catch (e) {
      _showSnackBar('URLを開けませんでした: $e');
      logger.e('URLを開けませんでした。\n $url \nError: $e');
      // ここでより詳細なエラーハンドリングやデバッグ情報の出力を行う
    }
  }

  void _showSnackBar(String message) {
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      logger.w(message);
    }
  }

  static Future<void> openUrlStatic(String url) async {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      Logger().w('無効なURLです。');
      return;
    }

    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        Logger().e('URLを開けませんでした。\n $url \nError: $e');
      }
    } else {
      Logger().e('URLを開けませんでした。');
    }
  }
}
