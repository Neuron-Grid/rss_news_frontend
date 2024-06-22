import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlOpener {
  final BuildContext context;
  UrlOpener(this.context);

  Future<void> openUrl(String url) async {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      _showSnackBar('無効なURLです。');
      return;
    }

    if (await canLaunchUrl(uri)) {
      try {
        // 外部のブラウザでURLを開く
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
    if (context.mounted) {
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger != null) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }
}
