import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rss_news/feed/timestamped_feed_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedService {
  static final Map<String, CachedFeed> feedCache = {};

  // Supabase Edge FunctionのURLを読み込む
  static final String edgeFunctionUrl = dotenv.env['EDGE_FUNCTION_URL']!;

  Future<List<TimestampedFeedItem<dynamic>>> fetchAndSortUserFeeds(
      SupabaseClient supabase, String userId) async {
    try {
      await forceUpdateFeeds();
      final feedList = await fetchUserFeeds(supabase, userId);
      final List<TimestampedFeedItem<dynamic>> allFeedItems = [];
      for (var feed in feedList) {
        final feedUrl = feed['url'];
        final feedItems = await fetchFeedWithCache(feedUrl);
        allFeedItems.addAll(feedItems);
      }
      allFeedItems.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return allFeedItems;
    } catch (e) {
      throw Exception('ユーザーのフィードの取得と解析に失敗しました: $e');
    }
  }

  Future<void> forceUpdateFeeds() async {
    try {
      final response = await http.post(
        Uri.parse(edgeFunctionUrl),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Edge Functionの呼び出しに失敗しました: ${response.body}');
      }
    } catch (e) {
      throw Exception('フィードの強制更新に失敗しました: $e');
    }
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
      throw Exception('ユーザーのフィードの取得に失敗しました: $e');
    }
  }

  Future<List<TimestampedFeedItem<dynamic>>> fetchFeedWithCache(String url,
      {bool useCache = true}) async {
    const cacheDuration = Duration(minutes: 10);
    final now = DateTime.now();
    // キャッシュが存在し、有効であればキャッシュを使用
    if (useCache && feedCache.containsKey(url)) {
      final cachedFeed = feedCache[url]!;
      if (now.difference(cachedFeed.timestamp) < cacheDuration) {
        return cachedFeed.feedItems;
      }
    }
    // キャッシュがない、または古い場合は新たに取得
    final feedItems = await fetchAndParseFeed(url);
    feedCache[url] = CachedFeed(feedItems, now);
    return feedItems;
  }

  Future<List<TimestampedFeedItem<dynamic>>> fetchAndParseFeed(
      String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('フィードの取得に失敗しました: $url');
      }
      final xmlData = response.body.toString();
      final feedType = determineFeedType(xmlData);
      final lastModified = response.headers['last-modified'];
      if (feedCache.containsKey(url) &&
          feedCache[url]!.lastModified == lastModified) {
        return feedCache[url]!.feedItems;
      }
      return parseFeed(xmlData, feedType);
    } catch (e) {
      throw Exception('フィードの解析に失敗しました: $e');
    }
  }

  List<TimestampedFeedItem<dynamic>> parseFeed(
      String xmlData, FeedTypes feedType) {
    switch (feedType) {
      case FeedTypes.rss:
        return RssFeedItems(xmlData).getItems();
      case FeedTypes.atom:
        return AtomFeedItems(xmlData).getItems();
      default:
        throw Exception('サポートされていないフィードタイプです: $feedType');
    }
  }

  FeedTypes determineFeedType(String xmlData) {
    if (xmlData.contains('<rss')) {
      return FeedTypes.rss;
    } else if (xmlData.contains('<feed')) {
      return FeedTypes.atom;
    } else {
      throw Exception('不明なフィードタイプです');
    }
  }
}

class CachedFeed {
  final List<TimestampedFeedItem<dynamic>> feedItems;
  final DateTime timestamp;
  final String? lastModified;
  CachedFeed(this.feedItems, this.timestamp, [this.lastModified]);
}

enum FeedTypes { rss, atom }
