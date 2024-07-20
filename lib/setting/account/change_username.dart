import 'package:flutter/material.dart';
import 'package:rss_news/validator/account_validator.dart';

class ChangeUsernamePage extends StatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  ChangeUsername createState() => ChangeUsername();
}

class ChangeUsername extends State<ChangeUsernamePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー名を変更'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '新しいユーザー名',
                ),
                validator: AccountValidator.validateEmail,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: AccountValidator.validatePassword,
              ),
              const SizedBox(height: 16.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          // TODO: Emailを変更する処理を実装する
                          // APIを呼び出して処理を実行する
                          // API呼び出し後にローディング状態を解除し、エラーメッセージなどを表示する
                        }
                      },
                      child: const Text('ユーザー名を変更'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
