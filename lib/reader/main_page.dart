import 'package:flutter/material.dart';
import 'package:rss_news/reader/add_feed.dart';
import 'package:rss_news/validator/url_opener.dart';
import 'package:rss_news/widget/reader/left_column.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }

  static of(BuildContext context) {}
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<MyHomePage> {
  Future<void> _refreshFeed() async {
    // TODO: フィードを更新するロジックをここに追加
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // 状態を更新する処理
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const LeftColumn(),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // スワイプが左から右に行われた時
            Scaffold.of(context).openDrawer();
          }
        },
        child: RefreshIndicator(
          onRefresh: _refreshFeed,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Title $index'),
                      subtitle: Text('This is the content of item $index.'),
                      onTap: () {
                        UrlOpener(context)
                            .openUrl('https://www.google.com/webhp?hl=ja');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFeed()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
