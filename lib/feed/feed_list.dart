import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/feed/timestamped_feed_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedList extends StatelessWidget {
  final SupabaseUserService authService;
  final void Function(String url) onFeedTap;
  final List<TimestampedFeedItem<dynamic>> feedItems;

  // キャッシュ用のMap
  static final Map<String, CachedFeed> _feedCache = {};

  const FeedList({
    super.key,
    required this.authService,
    required this.onFeedTap,
    required this.feedItems,
  });

  @override
  Widget build(BuildContext context) {
    final user = authService.getCurrentUser();

    if (user == null) {
      return const Center(child: Text('ユーザーが認証されていません'));
    }

    return FutureBuilder<List<TimestampedFeedItem<dynamic>>>(
      future: fetchAndParseFeeds(authService.client, user.id),
      builder: (BuildContext context,
          AsyncSnapshot<List<TimestampedFeedItem<dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('フィードの読み込み中にエラーが発生しました。再試行してください。'),
              ElevatedButton(
                onPressed: () {
                  // リトライロジック
                },
                child: const Text('再試行'),
              ),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final feedItems = snapshot.data!;
        if (feedItems.isEmpty) {
          return const Center(child: Text('フィードが見つかりません'));
        }

        return ListView.builder(
          itemCount: feedItems.length,
          itemBuilder: (context, index) {
            return buildFeedItem(context, feedItems[index]);
          },
        );
      },
    );
  }

  Widget buildFeedItem(
      BuildContext context, TimestampedFeedItem<dynamic> feedItem) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10.0),
      title: Text(
        feedItem.item.title ?? 'No Title',
        style: const TextStyle(
          fontFamily: 'NotoSansMonoCJK',
          fontSize: 16.0,
        ),
      ),
      subtitle: Text(
        feedItem.dateTime.toString(),
        style: const TextStyle(
          fontFamily: 'NotoSansMonoCJK',
          fontSize: 14.0,
        ),
      ),
      onTap: () {
        onFeedTap(feedItem.item.link ?? '');
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchUserFeeds(
      SupabaseClient supabase, String userId) async {
    try {
      final response =
          await supabase.from('feeds').select().eq('user_id', userId);
      return (response as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('フィードの取得に失敗しました: $e');
    }
  }

// クラス外で定義
  Future<List<TimestampedFeedItem<dynamic>>> fetchAndParseFeeds(
      SupabaseClient supabase, String userId) async {
    try {
      final feedList = await fetchUserFeeds(supabase, userId);
      final List<TimestampedFeedItem<dynamic>> allFeedItems = [];
      for (var feed in feedList) {
        final feedUrl = feed['url'];
        final feedItems = await fetchFeed(feedUrl);
        allFeedItems.addAll(feedItems);
      }
      allFeedItems.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return allFeedItems;
    } catch (e) {
      throw Exception('フィードの取得と解析に失敗しました: $e');
    }
  }

  Future<List<TimestampedFeedItem<dynamic>>> fetchFeed(String url,
      {bool useCache = true}) async {
    const cacheDuration = Duration(minutes: 10);
    final now = DateTime.now();

    // キャッシュが存在し、有効期限内の場合はキャッシュを返す
    if (useCache && _feedCache.containsKey(url)) {
      final cachedFeed = _feedCache[url]!;
      if (now.difference(cachedFeed.timestamp) < cacheDuration) {
        return cachedFeed.feedItems;
      }
    }

    // 有効なキャッシュがない場合、フィードを再取得してキャッシュに保存
    final feedItems = await fetchAndParseFeed(url);
    _feedCache[url] = CachedFeed(feedItems, now);

    return feedItems;
  }

  Future<List<TimestampedFeedItem<dynamic>>> fetchAndParseFeed(
      String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load feed: $url');
      }

      final xmlData = response.body.toString();
      final feedType = getFeedType(xmlData);

      // 更新日付の比較によるキャッシュの管理
      final lastModified = response.headers['last-modified'];
      if (_feedCache.containsKey(url) &&
          _feedCache[url]!.lastModified == lastModified) {
        return _feedCache[url]!.feedItems;
      }

      switch (feedType) {
        case FeedTypes.rss:
          return RssFeedItems(xmlData).getItems();
        case FeedTypes.atom:
          return AtomFeedItems(xmlData).getItems();
        default:
          throw Exception('Unsupported feed type: $feedType');
      }
    } catch (e) {
      // エラーが発生した場合は空のリストを返す
      return [];
    }
  }

  // RSS または Atom フィードを判定するロジック
  FeedTypes getFeedType(String xmlData) {
    if (xmlData.contains('<rss')) {
      return FeedTypes.rss;
    } else if (xmlData.contains('<feed')) {
      return FeedTypes.atom;
    } else {
      throw Exception('Unknown feed type');
    }
  }
}

// キャッシュされたフィードの情報を保持するクラス
class CachedFeed {
  final List<TimestampedFeedItem<dynamic>> feedItems;
  final DateTime timestamp;
  final String? lastModified;

  CachedFeed(this.feedItems, this.timestamp, [this.lastModified]);
}

enum FeedTypes { rss, atom }
