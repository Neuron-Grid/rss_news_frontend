import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/feed/add_feed.dart';
import 'package:rss_news/feed/feed_list.dart';
import 'package:rss_news/feed/remove_feed.dart';
import 'package:rss_news/feed/timestamped_feed_item.dart';
import 'package:rss_news/validator/url_opener.dart';
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
  List<TimestampedFeedItem<dynamic>> _feedItems = []; // フィードアイテムのリストを管理
  bool _isLoading = false; // ローディング状態を管理

  @override
  void initState() {
    super.initState();
    final supabaseClient = Supabase.instance.client;
    authService = SupabaseUserService(supabaseClient);
    _refreshFeed(); // 初期フィードの取得
  }

  Future<void> _refreshFeed() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true; // ローディング中フラグをオン
    });

    final user = authService.getCurrentUser();
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ユーザーが認証されていません')),
        );
      }
      return;
    }

    try {
      // Supabaseからフィードデータを取得して解析
      final feedItems = await fetchAndParseFeeds(authService.client, user.id);

      if (mounted) {
        setState(() {
          _feedItems = feedItems;
          _isLoading = false; // ローディング完了
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('フィードを再取得しました')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false; // エラー時にもローディングフラグを解除
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('フィードの再取得に失敗しました: $e')),
        );
      }
    }
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
          onRefresh: _refreshFeed, // リフレッシュ時にフィードを再取得
          child: _isLoading
              ? const Center(child: CircularProgressIndicator()) // ローディング表示
              : FeedList(
                  authService: authService as SupabaseUserService,
                  onFeedTap: (String url) {
                    UrlOpener(context).openUrl(url);
                  },
                  feedItems: _feedItems, // FeedListにフィードデータを渡す
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
