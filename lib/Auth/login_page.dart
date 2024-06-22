import 'package:flutter/material.dart';
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
  final TextEditingController _usernameController = TextEditingController();
  final LoginService _loginService = LoginService();

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLoggedIn();
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    await _loginService.initialize();
    final bool isLoggedIn = await _loginService.isLoggedIn();
    if (!mounted) return;
    if (isLoggedIn) {
      _navigateToHomePage();
    }
  }

  Future<void> _authenticateUser() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String username = _usernameController.text;
      try {
        await _loginService.saveLoginInfo(email, username, password);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ログインに失敗しました。')),
        );
        return;
      }
      if (!mounted) return;
      _navigateToHomePage();
    }
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildLoginForm(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('ログイン'),
      backgroundColor: Colors.blue,
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: _buildFormFields(),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        UsernameInputField(controller: _usernameController),
        const SizedBox(height: 20),
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

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _authenticateUser,
      child: const Text('ログイン'),
    );
  }

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

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }
}
