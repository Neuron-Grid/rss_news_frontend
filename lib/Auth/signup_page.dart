import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rss_news/auth/login_service.dart';
import 'package:rss_news/validator/account_validator.dart';
import 'package:rss_news/widget/account_component.dart';

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
  final LoginService _loginService = LoginService();

  @override
  void initState() {
    super.initState();
    _loginService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規アカウント作成"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildEmailField(),
              const SizedBox(height: 20),
              _buildUsernameField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildSignUpButton(context),
              const SizedBox(height: 20),
              _buildLoginLink(context),
            ],
          ),
        ),
      ),
    );
  }

  // メールアドレス入力フィールドの生成
  Widget _buildEmailField() {
    return InputField(
      labelText: 'メールアドレス',
      controller: _emailController,
      validator: AccountValidator.validateEmail,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
    );
  }

  // ユーザー名入力フィールドの生成
  Widget _buildUsernameField() {
    return InputField(
      labelText: 'ユーザー名',
      controller: _usernameController,
      validator: AccountValidator.validateUsername,
    );
  }

  // パスワード入力フィールドの生成
  Widget _buildPasswordField() {
    return InputField(
      labelText: 'パスワード',
      controller: _passwordController,
      validator: AccountValidator.validatePassword,
      isObscure: true,
      icon: Icons.lock,
    );
  }

  // サインアップボタンの生成
  Widget _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('登録が成功しました。ログイン中です。')),
          );
          await _saveAccountInfo();
        }
      },
      child: const Text('サインアップ'),
    );
  }

  // ログインリンクの生成
  Widget _buildLoginLink(BuildContext context) {
    return InkWell(
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
    );
  }

  // 登録情報の保存
  Future<void> _saveAccountInfo() async {
    try {
      await _loginService.saveLoginInfo(
        _emailController.text,
        _usernameController.text,
        _passwordController.text,
      );
    } catch (e) {
      Logger().e('Failed to save account info.\n $e');
    }
  }
}
