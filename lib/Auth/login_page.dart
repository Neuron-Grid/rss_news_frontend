import 'package:flutter/material.dart';
import 'package:rss_news/auth/auth_service.dart';
import 'package:rss_news/auth/signup_page.dart';
import 'package:rss_news/reader/main_page.dart';
import 'package:rss_news/widget/account_component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    final SupabaseClient client = Supabase.instance.client;
    _authService = SupabaseUserService(client);
    _checkIfAlreadyLoggedIn();
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    final User? currentUser = _authService.getCurrentUser();
    if (!mounted) return;
    if (currentUser != null) {
      _navigateToHomePage();
    }
  }

  Future<void> _authenticateUser() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String password = _passwordController.text;
      try {
        final user = await _authService.signIn(email, password);
        if (!mounted) return;
        if (user != null) {
          _navigateToHomePage();
        } else {
          _showError('ログインに失敗しました。ユーザーが見つかりません。');
        }
      } catch (e) {
        _showError('ログイン中にエラーが発生しました: $e');
      }
    }
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
      child: SingleChildScrollView(
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _authenticateUser,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'ログイン',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: _navigateToSignUp,
        child: const Text(
          'アカウントを持ってない方はこちら',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
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
