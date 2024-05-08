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

  const InputField({
    super.key,
    required this.labelText,
    required this.controller,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.icon,
    required this.validator,
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        suffixIcon: _obscureText
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: togglePasswordVisibility,
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}

// ユーザー名入力フィールドウィジェット
class UsernameInputField extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  UsernameInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return InputField(
      labelText: 'ユーザー名',
      controller: controller,
      validator: AccountValidator.validateUsername,
    );
  }
}

// パスワード入力フィールドウィジェット
class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInputField({super.key, required this.controller});

  @override
  State<PasswordInputField> createState() => PasswordInputFieldState();
}

class PasswordInputFieldState extends State<PasswordInputField> {
  @override
  Widget build(BuildContext context) {
    return InputField(
      labelText: 'パスワード',
      controller: widget.controller,
      isObscure: true,
      validator: AccountValidator.validatePassword,
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
      labelText: 'Email',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: AccountValidator.validateEmail,
    );
  }
}
