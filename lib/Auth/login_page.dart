import 'package:flutter/material.dart';
import 'package:rss_news/auth/signup_page.dart';
import 'package:rss_news/widget/account_component.dart';
import 'package:rss_news/widget/common_styles.dart';
import 'package:rss_news/reader/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ユーザー認証を行う
  void _authenticateUser() {
    if (_formKey.currentState!.validate()) {
      _showLoginSuccess();
    }
  }

  // ログイン成功時のスナックバーを表示
  void _showLoginSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('成功しました。ログイン中です。'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildLoginForm(),
    );
  }

  // アプリバーを生成
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('ログイン'),
      backgroundColor: Colors.blue,
    );
  }

  // ログインフォームを生成
  Widget _buildLoginForm() {
    return Center(
      child: Container(
        padding: CommonStyles.pagePadding,
        child: Form(
          key: _formKey,
          child: _formFields(),
        ),
      ),
    );
  }

  // フォームフィールドを生成
  Widget _formFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        EmailInputField(controller: _emailController),
        const SizedBox(height: 20),
        PasswordInputField(controller: _passwordController),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 20),
        _buildSignUpLink(),
      ],
    );
  }

  // ログインボタンを生成
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _authenticateUser,
      child: const Text('ログイン'),
    );
  }

  // サインアップリンクを生成
  Widget _buildSignUpLink() {
    return InkWell(
      onTap: _navigateToSignUp,
      child: const Text(
        'アカウントを持ってない方はこちら',
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // サインアップページへのナビゲーション
  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }
}
