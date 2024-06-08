import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rss_news/auth/login_service.dart';
import 'package:rss_news/auth/signup_page.dart';
import 'package:rss_news/reader/main_page.dart';
import 'package:rss_news/widget/account_component.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService _loginService = LoginService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loginService.initialize();
  }

  void _authenticateUser() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      // Encrypt email and password
      String encryptedEmail = await _loginService.encrypt(email);
      String encryptedPassword = await _loginService.encrypt(password);

      // Store encrypted data
      await _storage.write(key: 'email', value: encryptedEmail);
      await _storage.write(key: 'password', value: encryptedPassword);

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
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
        padding: const EdgeInsets.all(16.0),
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
