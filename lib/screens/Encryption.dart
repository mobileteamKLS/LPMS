import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';

class EncryptionService {
  final String keys = "OMS1@2020#^@El@K";
  String encryptUsingRandomKey(String value, String userKey) {
    String key1 = keys.substring(0, keys.length - 2) + userKey;
    // final key = encrypt.Key.fromUtf8(key1.substring(0, 16));
    // final iv = encrypt.IV.fromLength(16);

    final key = Key.fromUtf8(key1);
    final iv = IV.fromUtf8(key1);
    // final encrypter = encrypt.Encrypter(
    //     encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'));

    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: 'PKCS7'));
    if (value.isNotEmpty) {
      // final encrypted = encrypter.encrypt(value, iv: iv);
      final encrypted = encrypter.encrypt(jsonEncode(value), iv: iv);
      return encrypted.base64;
    } else {
      return "";
    }
  }

  String encryptUsingRandomKeyPrivateKey(dynamic value) {
    // String key1 = keys.substring(0, keys.length - 2) + userKey;
    // // final key = encrypt.Key.fromUtf8(key1.substring(0, 16));
    // // final iv = encrypt.IV.fromLength(16);

    final key = Key.fromUtf8(keys);
    final iv = IV.fromUtf8(keys);
    // final encrypter = encrypt.Encrypter(
    //     encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'));

    final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: 'PKCS7'));
    if (value.isNotEmpty) {
      // final encrypted = encrypter.encrypt(value, iv: iv);
      final encrypted = encrypter.encrypt(jsonEncode(value), iv: iv);
      return encrypted.base64;
    } else {
      return "";
    }
  }

  // String encryptUsingRandomKey(String value, String userKey) {
  //
  //   String key1 = keys.substring(0, keys.length - 2) + userKey;
  //
  //   final key = encrypt.Key.fromUtf8(key1.padRight(16, '0').substring(0, 16));
  //   final iv = encrypt.IV.fromUtf8(key1.padRight(16, '0').substring(0, 16));
  //
  //   final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'));
  //
  //   if (value.isNotEmpty) {
  //     final encrypted = encrypter.encrypt(json.encode(value), iv: iv);
  //     return encrypted.base64;
  //   } else {
  //     return '';
  //   }
  // }

  String decryptUsingRandomKey(String encryptedValue, String userKey) {
    String key1 = keys.substring(0, keys.length - 2) + userKey;
    final key = encrypt.Key.fromUtf8(key1.substring(0, 16));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'));

    if (encryptedValue.isNotEmpty) {
      final decrypted = encrypter.decrypt64(encryptedValue, iv: iv);
      return decrypted;
    } else {
      return "";
    }
  }
}

