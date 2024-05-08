import 'package:flutter/material.dart';
import 'package:rss_news/widget/account_component.dart';
import 'package:rss_news/validator/account_validator.dart';
import 'package:rss_news/widget/common_styles.dart';

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
        // ヘッダーを青色に設定
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        // 上下の間隔を追加
        padding: CommonStyles.pagePadding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              InputField(
                labelText: 'メールアドレス',
                controller: _emailController,
                validator: AccountValidator.validateEmail,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              InputField(
                labelText: 'ユーザー名',
                controller: _usernameController,
                validator: AccountValidator.validateUsername,
              ),
              const SizedBox(height: 20),
              InputField(
                labelText: 'パスワード',
                controller: _passwordController,
                validator: AccountValidator.validatePassword,
                isObscure: true,
                icon: Icons.lock,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('登録が成功しました。ログイン中です。')),
                    );
                  }
                },
                child: const Text('ログイン'),
              ),
              // ログインページへのリンク
              const SizedBox(height: 20),
              InkWell(
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
            ],
          ),
        ),
      ),
    );
  }
}
