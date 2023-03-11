import 'package:encrypt/encrypt.dart';

Encrypted encryptWithAES(String key, String plainText) {
  final cipherKey = Key.fromUtf8(key);
  final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(key.substring(0,
      16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

  Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
  return encryptedData;
}

// String decryptWithAES(String key, Encrypted encryptedData) {
String decryptWithAES(String key, String encryptedData) {
  final cipherKey = Key.fromUtf8(key);
  final encryptService =
      Encrypter(AES(cipherKey, mode: AESMode.cbc)); //Using AES CBC encryption
  final initVector = IV.fromUtf8(key.substring(0,
      16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.
  // Encrypter.decrypt64(source, iv: iv);
  return encryptService.decrypt64(encryptedData, iv: initVector);
}
