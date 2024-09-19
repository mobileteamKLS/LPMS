import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
class EncryptionService {

  final String keys = "OMS1@2020#^@El@K";

  String encryptUsingRandomKey(String value, String userKey) {

    String key1 = keys.substring(0, keys.length - 2) + userKey;


    final key = encrypt.Key.fromUtf8(key1.substring(0, 16));


    final iv = encrypt.IV.fromLength(16);


    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'));

    if (value.isNotEmpty) {

      final encrypted = encrypter.encrypt(value, iv: iv);


      return encrypted.base64;
    } else {
      return "";
    }
  }
}