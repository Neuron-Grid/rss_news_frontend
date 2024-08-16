import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

// 暗号化方式と関連変数の定義
final useCipher = Xchacha20.poly1305Aead();
const nonceLength = 24;
const macLength = 16;
// loggerのインスタンスを作成
final Logger logger = Logger();

class LoginService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late SecretKey _key;
  bool _isInitialized = false;

  // ログイン状態を確認する
  Future<bool> isLoggedIn() async {
    await _ensureInitialized();
    final username = await _storage.read(key: 'username');
    final password = await _storage.read(key: 'password');
    return username != null && password != null;
  }

  // ログアウト処理を行い、保存されたデータを削除する
  Future<void> logout() async {
    await _ensureInitialized();
    try {
      await _storage.deleteAll();
      _isInitialized = false;
    } catch (e) {
      logger.e('Failed to log out', error: e);
      throw Exception('ログアウト処理に失敗しました。');
    }
  }

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
      logger.e('Failed to initialize encryption key', error: e);
      throw Exception('セキュリティ上のエラーが発生しました。');
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
      logger.e('Encryption failed', error: e);
      throw Exception('セキュリティ上のエラーが発生しました。');
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
      logger.e('Decryption failed', error: e);
      throw Exception('セキュリティ上のエラーが発生しました。');
    }
  }

  // 暗号化されたログイン情報を安全なストレージに保存する
  Future<void> saveLoginInfo(
      String email, String username, String password) async {
    await _ensureInitialized();
    try {
      await Future.wait([
        _storage.write(key: 'username', value: await encrypt(username)),
        _storage.write(key: 'password', value: await encrypt(password)),
      ]);
    } catch (e) {
      logger.e('Failed to save login information', error: e);
      throw Exception('セキュリティ上のエラーが発生しました。');
    }
  }

  // 安全なストレージからログイン情報を取得し、復号化する
  Future<Map<String, String>> getLoginInfo() async {
    await _ensureInitialized();
    final keys = await Future.wait([
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
      ]);

      return {
        'username': decryptedKeys[0],
        'password': decryptedKeys[1],
      };
    } catch (e) {
      logger.e('Failed to retrieve login information', error: e);
      throw Exception('セキュリティ上のエラーが発生しました。');
    }
  }
}
