import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthService {
  get client => null;

  User? getCurrentUser();
  String getEmail(User? user);
  String getCreationDate(User? user);
  Future<void> signOut();
  Future<User?> signIn(String email, String password);
}

class SupabaseUserService implements AuthService {
  @override
  final SupabaseClient client;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  SupabaseUserService(this.client);

  @override
  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  @override
  String getEmail(User? user) {
    return user?.email ?? '不明';
  }

  @override
  String getCreationDate(User? user) {
    if (user?.createdAt is DateTime) {
      return (user?.createdAt as DateTime).toIso8601String();
    } else {
      return user?.createdAt ?? '不明';
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
      await _clearStoredTokens();
    } catch (error) {
      _handleError('サインアウトに失敗しました', error);
    }
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw AuthException('ユーザーが見つかりません');
      }

      await _storeTokens(
          response.session?.accessToken, response.session?.refreshToken);
      return user;
    } catch (error) {
      return Future.error(_handleError('ログインに失敗しました', error));
    }
  }

  Future<String?> getSecureToken(String key) async {
    return await secureStorage.read(key: key);
  }

  Future<void> _storeTokens(String? accessToken, String? refreshToken) async {
    if (accessToken != null) {
      await secureStorage.write(key: 'accessToken', value: accessToken);
    }
    if (refreshToken != null) {
      await secureStorage.write(key: 'refreshToken', value: refreshToken);
    }
  }

  Future<void> _clearStoredTokens() async {
    await secureStorage.delete(key: 'accessToken');
    await secureStorage.delete(key: 'refreshToken');
  }

  String _handleError(String message, dynamic error) {
    final errorMessage = '$message: ${error.toString()}';
    return errorMessage;
  }

  Future<void> changeEmail(String newEmail, String password) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) {
        throw AuthException('ユーザーがログインしていません');
      }
      // 再認証のためにパスワードでサインイン
      final response = await client.auth.signInWithPassword(
        email: currentUser.email!,
        password: password,
      );
      if (response.user == null) {
        throw AuthException('再認証に失敗しました');
      }
      // メールアドレスの更新
      await client.auth.updateUser(UserAttributes(email: newEmail));
      // トークンの更新（必要に応じて）
      await _storeTokens(
          response.session?.accessToken, response.session?.refreshToken);
    } catch (error) {
      throw AuthException('メールアドレスの変更に失敗しました: ${error.toString()}');
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() {
    return 'AuthException: $message';
  }
}
