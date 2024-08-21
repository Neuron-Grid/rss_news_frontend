import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
        elevation: 0,
      ),
      body: Center(
        child: user == null
            ? const Text(
                'ユーザー情報が見つかりません',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: UserInfoDisplay(authService: authService, user: user),
              ),
      ),
    );
  }
}

class UserInfoDisplay extends StatelessWidget {
  final AuthService authService;
  final User user;

  const UserInfoDisplay({
    super.key,
    required this.authService,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(
              label: 'メールアドレス',
              value: authService.getEmail(user),
              onTap: () => _copyToClipboard(
                  context, 'メールアドレス', authService.getEmail(user)),
            ),
            const SizedBox(height: 16),
            InfoRow(
              label: 'アカウント作成日時',
              value: _formatDate(authService.getCreationDate(user)),
              onTap: () => _copyToClipboard(context, 'アカウント作成日時',
                  _formatDate(authService.getCreationDate(user))),
            ),
          ],
        ),
      ),
    );
  }
}

void _copyToClipboard(BuildContext context, String label, String text) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$labelをコピーしました。'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.teal,
    ),
  );
}

String _formatDate(String isoString) {
  final DateTime dateTime = DateTime.parse(isoString);
  final DateFormat formatter = DateFormat('yyyy年MM月dd日HH時mm分ss秒');
  return formatter.format(dateTime);
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.teal, size: 20),
              onPressed: onTap,
            ),
          ],
        ),
      ],
    );
  }
}
