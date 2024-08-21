import 'package:flutter/material.dart';
import 'package:rss_news/reader/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddFeed extends StatelessWidget {
  const AddFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RSSフィードを追加'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildTextField(titleController, 'タイトル'),
                const SizedBox(height: 16),
                _buildTextField(urlController, 'RSSフィードのURL'),
                const SizedBox(height: 32),
                _buildSaveButton(
                    context, supabase, userId, titleController, urlController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // テキストフィールドのウィジェットを構築
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // 保存ボタンのウィジェットを構築
  Widget _buildSaveButton(
      BuildContext context,
      SupabaseClient supabase,
      String? userId,
      TextEditingController titleController,
      TextEditingController urlController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _saveFeed(context, supabase, userId,
            titleController.text, urlController.text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('保存'),
      ),
    );
  }

  // フィードを保存するロジック
  Future<void> _saveFeed(BuildContext context, SupabaseClient supabase,
      String? userId, String title, String url) async {
    if (!_validateInputs(context, title, url, userId)) return;
    try {
      // 既存のフィードを確認
      final existingFeedId =
          await _checkExistingFeed(supabase, userId!, url, title);
      if (!context.mounted) return;
      if (existingFeedId != null) {
        _showSnackBar(context, 'このフィードは既に登録されています');
        return;
      }

      // 新しいフィードを挿入
      final feedId = await _insertFeed(supabase, userId, title, url);
      if (!context.mounted) return;
      if (feedId != null) {
        await _subscribeToFeed(context, supabase, userId, feedId);
      } else {
        _showSnackBar(context, 'エラーが発生しました: フィードの追加に失敗しました');
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'フィードの追加中にエラーが発生しました: $e');
      }
    }
  }

  // 既存のフィードを確認するロジック
  Future<dynamic> _checkExistingFeed(
      SupabaseClient supabase, String userId, String url, String title) async {
    final response = await supabase
        .from('feeds')
        .select('id')
        .eq('user_id', userId)
        .eq('url', url)
        .eq('title', title)
        .maybeSingle();

    return response != null ? response['id'] : null;
  }

  // フィードのデータを挿入
  Future<dynamic> _insertFeed(
      SupabaseClient supabase, String userId, String title, String url) async {
    final response = await supabase
        .from('feeds')
        .insert({
          'user_id': userId,
          'url': url,
          'title': title,
        })
        .select('id')
        .single();
    return response.isNotEmpty ? response['id'] : null;
  }

  // サブスクリプションを作成
  Future<void> _subscribeToFeed(BuildContext context, SupabaseClient supabase,
      String userId, dynamic feedId) async {
    try {
      final subscriptionResponse = await supabase.from('subscriptions').insert({
        'user_id': userId,
        'feed_id': feedId,
      });
      if (!context.mounted) return;
      if (subscriptionResponse != null && subscriptionResponse.isNotEmpty) {
        _showSnackBar(context, 'RSSフィードが追加されました');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPageApp()),
        );
      } else {
        _showSnackBar(context, 'サブスクリプションの登録に失敗しました。\nデータが返されませんでした');
      }
    } catch (e) {
      _showSnackBar(context, 'サブスクリプションの登録中にエラーが発生しました: $e');
    }
  }

  // 入力データのバリデーション
  bool _validateInputs(
      BuildContext context, String title, String url, String? userId) {
    if (title.isEmpty || url.isEmpty) {
      _showSnackBar(context, 'タイトルとURLを入力してください');
      return false;
    }
    if (userId == null) {
      _showSnackBar(context, 'ユーザーが認証されていません');
      return false;
    }
    return true;
  }

  // SnackBarメッセージを表示
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
