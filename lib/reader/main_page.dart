import 'package:flutter/material.dart';
import 'package:rss_news/widget/reader/left_column.dart';

void main() => runApp(const MyApp());

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
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // サイドメニューの表示状態を管理する変数
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _isDrawerOpen = !_isDrawerOpen;
            });
          },
        ),
      ),
      // サイドメニューを表示/非表示
      drawer: _isDrawerOpen ? const LeftColumn() : null,
      body: Row(
        children: <Widget>[
          _isDrawerOpen
              ? Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue,
                  ),
                )
              // サイドメニューが非表示の場合は空のContainerを表示
              : Container(),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
