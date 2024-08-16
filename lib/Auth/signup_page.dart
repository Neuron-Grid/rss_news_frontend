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
  final TextEditingController _usernameController = TextEditingController();

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildUsernameField(),
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

  Widget _buildUsernameField() {
    return InputField(
      labelText: 'ユーザー名',
      controller: _usernameController,
      validator: AccountValidator.validateUsername,
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
      final currentContext = context;
      _showSnackBar(context, '登録処理を行っています...');
      final success = await _attemptSignUp();
      final message = success ? 'アカウントが作成されました！' : 'アカウント作成に失敗しました。';
      if (!mounted) return;
      _showSnackBar(currentContext, message);
    }
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
        data: {'username': _buildUsernameField()},
      );
      if (response.user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('アカウント作成に失敗しました。')),
          );
        }
        return false;
      }
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('アカウント作成中にエラーが発生しました: $e')),
        );
      }
      return false;
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
