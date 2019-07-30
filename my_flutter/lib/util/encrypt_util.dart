import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/pointycastle.dart';

/// 加密工具类
class EncryptUtil {
  static String sha512(String string) {
    return sha(string, "sha-512");
  }

  static String sha(String string, String alg) {
    try {
      Digest digest;
      if (alg == "sha-512") {
        digest = new SHA512Digest();
      }
      List<int> utf8List = utf8.encode(string);
      Uint8List result = digest.process(Uint8List.fromList(utf8List));
      String ss = "";
      result.forEach((num) {
        ss = ss + num.toRadixString(16).padLeft(2, '0');
      });
      return ss.toLowerCase();
    } catch (e) {
      print(e);
    }
    return null;
  }
}
