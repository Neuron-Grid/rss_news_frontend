import 'package:flutter/material.dart';
import 'package:rss_news/validator/account_validator.dart';

// 入力フィールドのベースウィジェット
class InputField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isObscure;
  final TextInputType keyboardType;
  final IconData? icon;
  final String? Function(String? value) validator;
  final bool hasOutline;

  const InputField({
    super.key,
    required this.labelText,
    required this.controller,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.icon,
    required this.validator,
    this.hasOutline = true,
  });

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObscure;
  }

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border:
            widget.hasOutline ? const OutlineInputBorder() : InputBorder.none,
        suffixIcon: widget.isObscure
            ? IconButton(
                // isObscureがtrueの場合のみアイコンを表示
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: togglePasswordVisibility,
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}

// Email入力フィールドウィジェット
class EmailInputField extends StatelessWidget {
  final TextEditingController controller;

  const EmailInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InputField(
      labelText: 'メールアドレス',
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      isObscure: false,
      // メールアドレスのバリデーションを適用
      validator: AccountValidator.validateEmail,
      hasOutline: true,
    );
  }
}

// パスワード入力フィールドウィジェット
class PasswordInputField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InputField(
      labelText: 'パスワード',
      keyboardType: TextInputType.visiblePassword,
      controller: controller,
      isObscure: true,
      // パスワードのバリデーションを適用
      validator: AccountValidator.validatePassword,
      hasOutline: true,
    );
  }
}

// ユーザー名入力フィールドウィジェット
class UsernameInputField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InputField(
      labelText: 'パスワード',
      keyboardType: TextInputType.text,
      controller: controller,
      isObscure: false,
      // ユーザー名のバリデーションを適用
      validator: AccountValidator.validateUsername,
      hasOutline: true,
    );
  }
}
