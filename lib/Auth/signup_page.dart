import 'package:flutter/material.dart';
import 'package:rss_news/validator/account_validator.dart';
import 'package:rss_news/widget/account_component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規アカウント作成"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildSignUpButton(),
                const SizedBox(height: 20),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return InputField(
      labelText: 'メールアドレス',
      controller: _emailController,
      validator: AccountValidator.validateEmail,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
    );
  }

  Widget _buildPasswordField() {
    return InputField(
      labelText: 'パスワード',
      controller: _passwordController,
      validator: AccountValidator.validatePassword,
      isObscure: true,
      icon: Icons.lock,
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSignUp,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'サインアップ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      _processSignUp(context);
    }
  }

  void _processSignUp(BuildContext currentContext) async {
    _showSnackBar(currentContext, '登録処理を行っています...');
    final success = await _attemptSignUp();
    final message = success ? 'アカウントが作成されました！' : 'アカウント作成に失敗しました。';
    if (!currentContext.mounted) return;
    _showSnackBar(currentContext, message);
  }

  void _showSnackBar(BuildContext context, String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<bool> _attemptSignUp() async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return false;
      if (response.user == null) {
        _showSnackBar(context, 'アカウント作成に失敗しました。');
        return false;
      }

      return true;
    } catch (e) {
      final errorMessage = e is AuthException ? e.message : '不明なエラーが発生しました';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('アカウント作成中にエラーが発生しました: $errorMessage')),
        );
      }
      return false;
    }
  }

  void showSnackBar(BuildContext context, String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Widget _buildLoginLink() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Text(
          'アカウントを持っている方はこちら',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
