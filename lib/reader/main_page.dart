import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/feed/add_feed.dart';
import 'package:rss_news/feed/feed_list.dart';
import 'package:rss_news/feed/remove_feed.dart';
import 'package:rss_news/widget/reader/left_column.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainPageApp extends StatelessWidget {
  const MainPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MainPage(),
      ),
    );
  }

  static of(BuildContext context) {}
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    final supabaseClient = Supabase.instance.client;
    authService = SupabaseUserService(supabaseClient);
  }

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
            Scaffold.of(context).openDrawer();
          }
        },
        child: RefreshIndicator(
          onRefresh: _refreshFeed,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child:
                    FeedList(authService: authService as SupabaseUserService),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RemoveFeed(authService: authService)),
              );
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFeed()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
