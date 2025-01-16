import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordHelper {
  static const _storage = FlutterSecureStorage();
  static const _hashKey = 'password_hash';

  static String generateSalt() {
    final salt = DateTime.now().millisecondsSinceEpoch.toString();
    return salt;
  }

  static String pbkdf2(String password, String salt) {
    final key = utf8.encode(password + salt);
    final hmac = Hmac(sha256, key);
    final hash = hmac.convert(utf8.encode(password));
    return hash.toString();
  }

  static Future<void> savePassword(String password) async {
    final salt = generateSalt();
    final hash = pbkdf2(password, salt);
    await _storage.write(key: _hashKey, value: hash);
    await _storage.write(key: 'salt', value: salt);
  }

  static Future<bool> verifyPassword(String password) async {
    final storedHash = await _storage.read(key: _hashKey);
    final storedSalt = await _storage.read(key: 'salt');
    print(storedHash);

    if (storedHash == null || storedSalt == null) {
      return false;
    }

    final hash = pbkdf2(password, storedSalt);
    return hash == storedHash;
  }
}


//   static String hashPasswordWithSalt(String password, String salt) {
//     final combined = password + salt;

//     final bytes = utf8.encode(combined);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }

//   static Future<void> savePassword(String password) async {
//     final salt = generateSalt();
//     final hash = hashPasswordWithSalt(password, salt);

//     await _storage.write(key: _hashKey, value: hash);
//     await _storage.write(key: 'salt', value: salt);
//   }

//   static Future<bool> verifyPassword(String password) async {
//     final storedHash = await _storage.read(key: _hashKey);
//     final storedSalt = await _storage.read(key: 'salt');

//     if (storedHash == null || storedSalt == null) {
//       return false;
//     }

//     final hash = hashPasswordWithSalt(password, storedSalt);
//     return hash == storedHash;
//   }
// }
