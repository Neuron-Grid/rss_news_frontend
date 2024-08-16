import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewAccountPage extends StatelessWidget {
  const ViewAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = SupabaseUserService(Supabase.instance.client);
    final user = authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント情報'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: user == null
            ? const Text('ユーザーが見つかりません')
            : UserInfoDisplay(authService: authService, user: user),
      ),
    );
  }
}

// ユーザー情報を表示するウィジェット
class UserInfoDisplay extends StatelessWidget {
  final AuthService authService;
  final User user;

  const UserInfoDisplay({
    super.key,
    required this.authService,
    required this.user,
  });

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('クリップボードにコピーしました: $text')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => _copyToClipboard(context, authService.getUsername(user)),
          child: Text('ユーザー名: ${authService.getUsername(user)}'),
        ),
        InkWell(
          onTap: () => _copyToClipboard(context, authService.getEmail(user)),
          child: Text('メールアドレス: ${authService.getEmail(user)}'),
        ),
        InkWell(
          onTap: () =>
              _copyToClipboard(context, authService.getCreationDate(user)),
          child: Text('アカウント作成日: ${authService.getCreationDate(user)}'),
        ),
      ],
    );
  }
}
