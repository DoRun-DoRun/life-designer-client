import 'dart:convert';

import '../constant/data.dart';

class DataUtils{
  static String pathToUrl(String value){
    return 'http://$ip$value';
  }

  static String plainToBase64(String plain){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}