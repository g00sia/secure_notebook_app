import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';

class EncryptionHelper {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _keyAlias = "aes_key";

  Future<void> _generateAndStoreKeyIfNeeded() async {
    final existingKey = await _secureStorage.read(key: _keyAlias);
    if (existingKey == null) {
      final random = Random.secure();
      final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
      final base64Key = base64Encode(keyBytes);

      await _secureStorage.write(key: _keyAlias, value: base64Key);
    }
  }

  Future<SecretKey> getKey() async {
    await _generateAndStoreKeyIfNeeded();
    final base64Key = await _secureStorage.read(key: _keyAlias);

    if (base64Key == null) {
      throw Exception("Key not found. Please generate one first.");
    }

    final keyBytes = base64Decode(base64Key);
    return SecretKey(keyBytes);
  }

  Future<List<int>> encryptData(
    String data,
  ) async {
    final aes = AesGcm.with256bits();
    final key = await getKey();

    final secretBox = await aes.encrypt(
      utf8.encode(data),
      secretKey: key,
    );

    return secretBox.concatenation();
  }

  Future<String> decryptData(List<int> encryptedData) async {
    final aes = AesGcm.with256bits();
    final key = await getKey();

    final secretBox = SecretBox.fromConcatenation(
      encryptedData,
      nonceLength: 12,
      macLength: 16,
    );

    final decryptedData = await aes.decrypt(
      secretBox,
      secretKey: key,
    );

    return utf8.decode(decryptedData);
  }

  Future<void> saveNoteSecurely(String note, String title) async {
    final encryptedNote = await encryptData(note);
    final encryptedTitle = await encryptData(title);

    await _secureStorage.write(
      key: "note",
      value: base64Encode(encryptedNote),
    );
    await _secureStorage.write(
      key: "title",
      value: base64Encode(encryptedTitle),
    );
  }

  Future<Map<String, String?>> loadNoteSecurely() async {
    final encryptedNote = await _secureStorage.read(key: "note");
    final encryptedTitle = await _secureStorage.read(key: "title");

    String? decryptedNote;
    String? decryptedTitle;

    if (encryptedNote != null) {
      // Deszyfrowanie notatki
      final encryptedNoteBytes = base64Decode(encryptedNote);
      decryptedNote = await decryptData(encryptedNoteBytes);
    }

    if (encryptedTitle != null) {
      // Deszyfrowanie tytułu
      final encryptedTitleBytes = base64Decode(encryptedTitle);
      decryptedTitle = await decryptData(encryptedTitleBytes);
    }

    return {
      "note": decryptedNote,
      "title": decryptedTitle,
    };
  }
}
