import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/feed/timestamped_feed_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedList extends StatelessWidget {
  final SupabaseUserService authService;

  const FeedList({super.key, required this.authService});

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
          return Text('Error: ${snapshot.error}');
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
            final feedItem = feedItems[index];
            return ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              title: Text(feedItem.item.title ?? 'No Title'),
              subtitle: Text(feedItem.dateTime.toString()),
            );
          },
        );
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

  Future<List<TimestampedFeedItem<dynamic>>> fetchAndParseFeeds(
      SupabaseClient supabase, String userId) async {
    try {
      final feedList = await fetchUserFeeds(supabase, userId);
      final List<TimestampedFeedItem<dynamic>> allFeedItems = [];
      for (var feed in feedList) {
        final feedUrl = feed['url'];
        final feedItems = await fetchAndParseFeed(feedUrl);
        allFeedItems.addAll(feedItems);
      }

      allFeedItems.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return allFeedItems;
    } catch (e) {
      throw Exception('フィードの取得と解析に失敗しました: $e');
    }
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

  FeedTypes getFeedType(String xmlData) {
    // RSS または Atom フィードを判定するロジック
    if (xmlData.contains('<rss')) {
      return FeedTypes.rss;
    } else if (xmlData.contains('<feed')) {
      return FeedTypes.atom;
    } else {
      throw Exception('Unknown feed type');
    }
  }
}

enum FeedTypes { rss, atom }
