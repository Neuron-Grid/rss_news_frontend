import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 暗号化方式と関連変数の定義
final useCipher = Xchacha20.poly1305Aead();
const nonceLength = 24;
const macLength = 16;

class LoginService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late SecretKey _key;
  bool _isInitialized = false;

  // コンストラクタ
  LoginService();

  // サービスを初期化して暗号化キーを設定する
  Future<void> initialize() async {
    await _initializeKey();
    _isInitialized = true;
  }

  // 安全なストレージから暗号鍵を生成または取得する
  Future<void> _initializeKey() async {
    try {
      String? storedKey = await _storage.read(key: 'encryption_key');
      if (storedKey == null) {
        final key = await _generateEncryptionKey();
        final encodedKey = base64UrlEncode(await key.extractBytes());
        await _storage.write(key: 'encryption_key', value: encodedKey);
        storedKey = encodedKey;
      }
      _key = SecretKey(base64Url.decode(storedKey));
    } catch (e) {
      throw Exception('Failed to initialize encryption key: $e');
    }
  }

  // 新しい暗号鍵を生成する
  Future<SecretKey> _generateEncryptionKey() async {
    return useCipher.newSecretKey();
  }

  // 暗号化用のランダムなノンスを生成する
  Uint8List _generateNonce() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(nonceLength, (_) => random.nextInt(256)),
    );
  }

  // サービスが初期化されていることを確認する
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // 文字列値を暗号化する
  Future<String> encrypt(String value) async {
    await _ensureInitialized();
    try {
      final nonce = _generateNonce();
      final secretBox = await useCipher.encrypt(
        utf8.encode(value),
        secretKey: _key,
        nonce: nonce,
      );
      return base64UrlEncode(secretBox.concatenation());
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  // 文字列値を復号化する
  Future<String> decrypt(String value) async {
    await _ensureInitialized();
    try {
      final secretBox = SecretBox.fromConcatenation(
        base64Url.decode(value),
        nonceLength: nonceLength,
        macLength: macLength,
      );
      final decrypted = await useCipher.decrypt(secretBox, secretKey: _key);
      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  // 全てのデータを削除し、ログアウトする
  Future<void> logout() async {
    await _storage.deleteAll();
    _isInitialized = false;
  }

  // ユーザーがログインしているかどうかをチェックする
  Future<bool> isLoggedIn() async {
    final keys = await Future.wait([
      _storage.read(key: 'encryption_key'),
      _storage.read(key: 'email'),
      _storage.read(key: 'username'),
      _storage.read(key: 'password'),
    ]);
    return keys.every((key) => key != null);
  }

  // 暗号化されたログイン情報を安全なストレージに保存する
  Future<void> saveLoginInfo(
      String email, String username, String password) async {
    await _ensureInitialized();
    try {
      await Future.wait([
        _storage.write(key: 'email', value: await encrypt(email)),
        _storage.write(key: 'username', value: await encrypt(username)),
        _storage.write(key: 'password', value: await encrypt(password)),
      ]);
    } catch (e) {
      throw Exception('Failed to save login information: $e');
    }
  }

  // 安全なストレージからログイン情報を取得し、復号化する
  Future<Map<String, String>> getLoginInfo() async {
    await _ensureInitialized();
    final keys = await Future.wait([
      _storage.read(key: 'email'),
      _storage.read(key: 'username'),
      _storage.read(key: 'password'),
    ]);

    if (keys.any((key) => key == null)) {
      throw Exception('Login information not found');
    }

    try {
      final decryptedKeys = await Future.wait([
        decrypt(keys[0]!),
        decrypt(keys[1]!),
        decrypt(keys[2]!),
      ]);

      return {
        'email': decryptedKeys[0],
        'username': decryptedKeys[1],
        'password': decryptedKeys[2],
      };
    } catch (e) {
      throw Exception('Failed to retrieve login information: $e');
    }
  }
}
