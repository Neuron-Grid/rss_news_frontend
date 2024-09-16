import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/feed/add_feed.dart';
import 'package:rss_news/feed/feed_list.dart';
import 'package:rss_news/feed/feed_service.dart';
import 'package:rss_news/feed/remove_feed.dart';
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
  late final FeedService feedService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _refreshFeed();
  }

  // サービスの初期化
  void _initializeServices() {
    final supabaseClient = Supabase.instance.client;
    authService = SupabaseUserService(supabaseClient);
    feedService = FeedService();
  }

  // フィードをリフレッシュする処理
  Future<void> _refreshFeed() async {
    if (!mounted) return;
    _setLoading(true);
    final user = authService.getCurrentUser();
    if (user == null) {
      _showMessage('ユーザーが認証されていません');
      _setLoading(false);
      return;
    }
    try {
      await feedService.forceUpdateFeeds();
      _showMessage('フィードを再取得しました');
    } catch (e) {
      _showMessage('フィードの再取得に失敗しました: $e');
    } finally {
      _setLoading(false);
    }
  }

  // ローディング状態を設定
  void _setLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }

  // メッセージを表示
  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // Drawerを開く処理
  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
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
                _openDrawer(context);
              },
            );
          },
        ),
      ),
      drawer: const LeftColumn(),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 1000) {
            _openDrawer(context);
          }
        },
        child: RefreshIndicator(
          onRefresh: _refreshFeed,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FeedList(
                  authService: authService as SupabaseUserService,
                  onFeedTap: (String url) {
                    UrlOpener(context).openUrl(url);
                  },
                  feedService: feedService,
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
                  builder: (context) => RemoveFeed(authService: authService),
                ),
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
