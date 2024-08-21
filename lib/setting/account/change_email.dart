import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/validator/account_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  ChangeEmail createState() => ChangeEmail();
}

class ChangeEmail extends State<ChangeEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final SupabaseUserService _authService =
      SupabaseUserService(Supabase.instance.client);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emailを変更する'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEmailField(),
                const SizedBox(height: 16.0),
                _buildPasswordField(),
                const SizedBox(height: 16.0),
                _isLoading
                    ? const CircularProgressIndicator()
                    : _buildChangeEmailButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: '新しいEmail',
      ),
      validator: AccountValidator.validateUsername,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      validator: AccountValidator.validatePassword,
    );
  }

  Widget _buildChangeEmailButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _changeEmail(context),
      child: const Text('Emailを変更する'),
    );
  }

  Future<void> _changeEmail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _authService.changeEmail(
          _emailController.text,
          _passwordController.text,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('メールアドレスが変更されました')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('メールアドレスの変更に失敗しました: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
