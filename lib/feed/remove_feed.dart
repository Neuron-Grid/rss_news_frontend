import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/reader/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoveFeed extends StatefulWidget {
  final AuthService authService;
  const RemoveFeed({super.key, required this.authService});

  @override
  RemoveFeedState createState() => RemoveFeedState();
}

class RemoveFeedState extends State<RemoveFeed> {
  final selectedFeeds = <dynamic>{};
  late final SupabaseClient supabase;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
    currentUser = widget.authService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSSフィードを削除'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'removeFeedFab',
        onPressed: selectedFeeds.isNotEmpty ? _deleteSelectedFeeds : null,
        child: const Icon(Icons.delete),
      ),
      body: Center(
        child: _buildFeedList(),
      ),
    );
  }

  Widget _buildFeedList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchUserFeeds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('エラーが発生しました: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('登録されたRSSフィードはありません');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final feed = snapshot.data![index];
              final isSelected = selectedFeeds.contains(feed['id']);
              return FeedTile(
                feed: feed,
                isSelected: isSelected,
                onChanged: (value) => _onFeedSelected(feed['id'], value),
                onTap: () => _toggleFeedSelection(feed['id']),
              );
            },
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchUserFeeds() async {
    if (currentUser == null) {
      return [];
    }
    final response = await supabase
        .from('feeds')
        .select('id, title, url')
        .eq('user_id', currentUser!.id);
    return response;
  }

  void _onFeedSelected(dynamic feedId, bool? value) {
    setState(() {
      if (value == true) {
        selectedFeeds.add(feedId);
      } else {
        selectedFeeds.remove(feedId);
      }
    });
  }

  void _toggleFeedSelection(dynamic feedId) {
    setState(() {
      if (selectedFeeds.contains(feedId)) {
        selectedFeeds.remove(feedId);
      } else {
        selectedFeeds.add(feedId);
      }
    });
  }

  Future<void> _deleteSelectedFeeds() async {
    if (currentUser == null) {
      _showSnackBar('ユーザー情報が見つかりません。再ログインしてください。');
      return;
    }
    try {
      await _deleteFeedsAndSubscriptions();
      setState(() {
        selectedFeeds.clear();
      });
      _showSnackBar('選択されたRSSフィードが削除されました');
    } catch (e) {
      _showSnackBar('RSSフィードの削除中にエラーが発生しました: $e');
    }
  }

  Future<void> _deleteFeedsAndSubscriptions() async {
    List<int> selectedFeedIds = selectedFeeds.map((id) => id as int).toList();
    try {
      for (var feedId in selectedFeedIds) {
        final response = await supabase.from('feeds').delete().eq('id', feedId);
        if (response.error != null) {
          throw Exception('Failed to delete feed: ${response.error.message}');
        }
        if (response.data == null || response.data.isEmpty) {
          throw Exception('No feeds were deleted.');
        }
      }
      selectedFeeds.clear();
      _showSnackBar('選択されたRSSフィードが正常に削除されました。');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPageApp()),
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('RSSフィードの削除中にエラーが発生しました: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class FeedTile extends StatelessWidget {
  final Map<String, dynamic> feed;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTap;

  const FeedTile({
    super.key,
    required this.feed,
    required this.isSelected,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(feed['title']),
      subtitle: Text(feed['url']),
      leading: Checkbox(
        value: isSelected,
        onChanged: onChanged,
      ),
      onTap: onTap,
    );
  }
}
