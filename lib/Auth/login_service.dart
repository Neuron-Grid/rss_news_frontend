import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 暗号化方式
final useCipher = Xchacha20.poly1305Aead();

class LoginService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late SecretKey _key;
  bool _isInitialized = false;

  // コンストラクタ
  LoginService();

  // 暗号化キーを設定してサービスを初期化する。
  Future<void> initialize() async {
    await _initializeKey();
    _isInitialized = true;
  }

  // 安全なストレージから暗号鍵を生成または取得する。
  Future<void> _initializeKey() async {
    String? storedKey = await _storage.read(key: 'encryption_key');
    if (storedKey == null) {
      final key = await _generateEncryptionKey();
      final encodedKey = base64UrlEncode(await key.extractBytes());
      await _storage.write(key: 'encryption_key', value: encodedKey);
      storedKey = encodedKey;
    }
    _key = SecretKey(base64Url.decode(storedKey));
  }

  // 新しい暗号鍵を生成する
  Future<SecretKey> _generateEncryptionKey() async {
    return useCipher.newSecretKey();
  }

  // 暗号化用のランダムなノンスを生成する。
  Uint8List _generateNonce() {
    final random = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(24, (_) => random.nextInt(256)));
  }

  // 続行する前にサービスが初期化されていることを確認する。
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // 与えられた文字列値を暗号化する
  Future<String> encrypt(String value) async {
    try {
      await _ensureInitialized();
      final nonce = _generateNonce();
      final secretBox = await useCipher.encrypt(
        utf8.encode(value),
        secretKey: _key,
        nonce: nonce,
      );
      final encryptedData = base64UrlEncode(secretBox.concatenation());
      return encryptedData;
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  // 与えられた文字列値を復号する
  Future<String> decrypt(String value) async {
    try {
      await _ensureInitialized();
      final secretBox = SecretBox.fromConcatenation(
        base64Url.decode(value),
        nonceLength: 24,
        macLength: 16,
      );
      final decrypted = await useCipher.decrypt(secretBox, secretKey: _key);
      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  // 全てのデータを削除し、ログアウトする。
  Future<void> logout() async {
    await _storage.deleteAll();
    _isInitialized = false;
  }

  // 暗号化キーの存在とログイン情報の存在を確認することで、ユーザーがログインしているかどうかをチェックする。
  Future<bool> isLoggedIn() async {
    final String? encryptionKey = await _storage.read(key: 'encryption_key');
    final String? email = await _storage.read(key: 'email');
    final String? username = await _storage.read(key: 'username');
    final String? password = await _storage.read(key: 'password');

    final bool hasAllCredentials = encryptionKey != null &&
        email != null &&
        username != null &&
        password != null;

    return hasAllCredentials;
  }

  // 暗号化されたログイン情報を安全なストレージに保存
  Future<void> saveLoginInfo(
      String email, String username, String password) async {
    await _ensureInitialized();
    await _storage.write(key: 'email', value: await encrypt(email));
    await _storage.write(key: 'username', value: await encrypt(username));
    await _storage.write(key: 'password', value: await encrypt(password));
  }

  // 安全なストレージからログイン情報を取得し、復号化します。
  Future<Map<String, String>> getLoginInfo() async {
    await _ensureInitialized();
    final email = await _storage.read(key: 'email');
    final username = await _storage.read(key: 'username');
    final password = await _storage.read(key: 'password');

    if (email != null && username != null && password != null) {
      return {
        'email': await decrypt(email),
        'username': await decrypt(username),
        'password': await decrypt(password),
      };
    } else {
      throw Exception('Login information not found');
    }
  }
}
