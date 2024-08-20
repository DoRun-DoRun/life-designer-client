import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> loginUser(String email, String authProvider) async {
  final url = Uri.parse('http://localhost:3000/users');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'authProvider': authProvider,
    }),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final accessToken = responseData['accessToken'];
    final refreshToken = responseData['refreshToken'];

    // SharedPreferences 인스턴스 생성
    final prefs = await SharedPreferences.getInstance();

    // 토큰 저장
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  } else {
    // 에러 처리
    throw Exception('Failed to login');
  }
}
