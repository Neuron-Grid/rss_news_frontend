import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/validator/account_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordPage extends StatefulWidget {
  final SupabaseUserService authService;
  const ChangePasswordPage({super.key, required this.authService});

  @override
  ChangePassword createState() => ChangePassword();
}

class ChangePassword extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _changePassword() async {
    if (!_validatePasswords()) return;
    try {
      final user = widget.authService.getCurrentUser();
      if (user == null) {
        _showErrorMessage('ユーザーが見つかりません');
        return;
      }
      final reauthResponse = await widget.authService.signIn(
        widget.authService.getEmail(user),
        _currentPasswordController.text.trim(),
      );
      if (reauthResponse != null) {
        await _updatePassword();
      }
    } catch (error) {
      _showErrorMessage('エラーが発生しました: $error');
    }
  }

  bool _validatePasswords() {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final passwordError = AccountValidator.validatePassword(newPassword);
    if (passwordError != null) {
      _showErrorMessage(passwordError);
      return false;
    }
    if (newPassword != confirmPassword) {
      _showErrorMessage('新しいパスワードが一致しません');
      return false;
    }
    return true;
  }

  Future<void> _updatePassword() async {
    try {
      final response = await widget.authService.client.auth.updateUser(
        UserAttributes(password: _newPasswordController.text.trim()),
      );
      if (response.user == null) {
        _showErrorMessage('エラーが発生しました: パスワードの更新に失敗しました');
      } else {
        _showSuccessMessage('パスワードが変更されました');
      }
    } catch (error) {
      _showErrorMessage('パスワードの更新に失敗しました: $error');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwordを変更'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildChangePasswordForm(),
        ),
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPasswordField(_currentPasswordController, '現在のパスワード'),
        const SizedBox(height: 16.0),
        _buildPasswordField(_newPasswordController, '新しいパスワード'),
        const SizedBox(height: 16.0),
        _buildPasswordField(_confirmPasswordController, 'パスワードの確認'),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _changePassword,
          child: const Text('Passwordを変更'),
        ),
      ],
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
