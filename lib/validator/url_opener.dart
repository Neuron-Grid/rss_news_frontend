import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlOpener {
  final BuildContext context;
  final Logger logger = Logger();

  // 名前付き引数を使用するコンストラクタ
  UrlOpener(this.context);

  Future<void> openUrl(String url) async {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      _showSnackBar('無効なURLです。');
      return;
    }

    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        _showSnackBar('URLを開けませんでした。');
      }
    } else {
      _showSnackBar('URLを開けませんでした。');
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

  // 静的メソッド
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
        Logger().e('URLを開けませんでした。');
      }
    } else {
      Logger().e('URLを開けませんでした。');
    }
  }
}
