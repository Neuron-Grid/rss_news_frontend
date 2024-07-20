import 'package:flutter/material.dart';
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
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
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
    );
  }
}
