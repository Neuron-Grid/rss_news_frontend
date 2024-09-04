import 'package:webfeed_plus/webfeed_plus.dart';

class TimestampedFeedItem<T> {
  final DateTime dateTime;
  final T item;
  TimestampedFeedItem(this.dateTime, this.item);
}

abstract class FeedItems {
  FeedItems(String xmlString) {
    parse(xmlString);
  }
  parse(String xmlString);
  List<TimestampedFeedItem> getItems();
}

class RssFeedItems extends FeedItems {
  late RssFeed _rssFeeds;
  RssFeedItems(super.xmlString);
  @override
  parse(String xmlString) {
    _rssFeeds = RssFeed.parse(xmlString);
  }

  @override
  List<TimestampedFeedItem<RssItem>> getItems() {
    return _rssFeeds.items!
        .map((RssItem rssItem) => TimestampedFeedItem<RssItem>(
            rssItem.pubDate ?? DateTime.now(), rssItem))
        .toList();
  }
}

class AtomFeedItems extends FeedItems {
  late AtomFeed _atomFeeds;
  AtomFeedItems(super.xmlString);
  @override
  parse(String xmlString) {
    _atomFeeds = AtomFeed.parse(xmlString);
  }

  @override
  List<TimestampedFeedItem<AtomItem>> getItems() {
    return _atomFeeds.items!
        .map((AtomItem atomItem) => TimestampedFeedItem<AtomItem>(
            atomItem.updated ?? DateTime.now(), atomItem))
        .toList();
  }
}
