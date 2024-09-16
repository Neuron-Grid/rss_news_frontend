import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/feed/feed_service.dart';
import 'package:rss_news/feed/timestamped_feed_item.dart';

class FeedList extends StatefulWidget {
  final SupabaseUserService authService;
  final void Function(String url) onFeedTap;
  final FeedService feedService;

  const FeedList({
    super.key,
    required this.authService,
    required this.onFeedTap,
    required this.feedService,
  });

  @override
  FeedListState createState() => FeedListState();
}

class FeedListState extends State<FeedList> {
  late Future<List<TimestampedFeedItem<dynamic>>> _futureFeeds;

  @override
  void initState() {
    super.initState();
    final user = widget.authService.getCurrentUser();
    if (user != null) {
      _futureFeeds = widget.feedService
          .fetchAndSortUserFeeds(widget.authService.client, user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authService.getCurrentUser();

    if (user == null) {
      return const Center(child: Text('ユーザーが認証されていません'));
    }

    return FutureBuilder<List<TimestampedFeedItem<dynamic>>>(
      future: _futureFeeds,
      builder: (BuildContext context,
          AsyncSnapshot<List<TimestampedFeedItem<dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('フィードの読み込み中にエラーが発生しました。再試行してください。'),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureFeeds = widget.feedService.fetchAndSortUserFeeds(
                        widget.authService.client, user.id);
                  });
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
        widget.onFeedTap(feedItem.item.link ?? '');
      },
    );
  }
}
