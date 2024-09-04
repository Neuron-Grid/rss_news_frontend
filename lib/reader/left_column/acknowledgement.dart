import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rss_news/validator/url_opener.dart';

class Acknowledgement extends StatelessWidget {
  const Acknowledgement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('謝辞'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            AcknowledgementContent(),
            SizedBox(height: 20),
            Producer(),
            SizedBox(height: 20),
            ProjectOverview(),
            SizedBox(height: 20),
            UsedModules(),
          ],
        ),
      ),
    );
  }
}

class OpenableText extends StatefulWidget {
  final String prefix;
  final String url;

  const OpenableText({super.key, required this.prefix, required this.url});

  @override
  OpenableTextState createState() => OpenableTextState();
}

class OpenableTextState extends State<OpenableText> {
  UrlOpener? urlOpener;

  @override
  Widget build(BuildContext context) {
    urlOpener ??= UrlOpener(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
        children: [
          TextSpan(
            text: widget.prefix,
          ),
          TextSpan(
            text: widget.url,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                urlOpener?.openUrl(widget.url);
              },
          ),
        ],
      ),
    );
  }
}

class ProjectOverview extends StatelessWidget {
  const ProjectOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'このプロジェクトの概要',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'このアプリはRSS News APIと連携して動作するように設計されています。\n'
          'RSS News APIは、アカウント管理機能があるRSSリーダーです。',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class UsedModules extends StatelessWidget {
  const UsedModules({super.key});

  static const titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const descriptionStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('使用したもの', style: titleStyle),
        SizedBox(height: 10),
        Text(
          'このアプリは、Flutterを使用して開発されたアプリケーションです。',
          style: descriptionStyle,
        ),
        OpenableText(prefix: 'flutter: ', url: 'https://flutter.dev'),
        OpenableText(
          prefix: 'flutter_test: ',
          url:
              'https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html',
        ),
        OpenableText(
          prefix: 'cupertino_icons: ',
          url:
              'https://api.flutter.dev/flutter/cupertino/CupertinoIcons-class.html',
        ),
        OpenableText(
          prefix: 'flutter_native_splash: ',
          url: 'https://pub.dev/packages/flutter_native_splash',
        ),
        OpenableText(
          prefix: 'flutter_lints: ',
          url: 'https://pub.dev/packages/flutter_lints',
        ),
        OpenableText(
          prefix: 'url_launcher: ',
          url: 'https://pub.dev/packages/url_launcher',
        ),
        OpenableText(
          prefix: 'Noto Sans CJK: ',
          url: 'https://github.com/notofonts/noto-cjk/tree/main/Sans',
        ),
      ],
    );
  }
}

class Producer extends StatelessWidget {
  const Producer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '制作者',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'このアプリは、Neuron Gridによって開発されました。',
          style: TextStyle(fontSize: 16),
        ),
        OpenableText(
          prefix: '連絡先: ',
          url: 'https://contact.neuron-grid.net/',
        ),
      ],
    );
  }
}

class AcknowledgementContent extends StatelessWidget {
  const AcknowledgementContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '謝辞',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'このプロジェクトの完成にあたり、多くの方々の支援と協力を得ることができました。'
          'オープンソースコミュニティの皆様には、貴重なリソースやツールを提供していただき、心から感謝申し上げます。',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
