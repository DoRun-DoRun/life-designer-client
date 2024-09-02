import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider =
    Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

const ACCESS_TOKEN_KEY = 'accessToken';
const REFRESH_TOKEN_KEY = 'refreshToken';

// Secure storage instance
const storage = FlutterSecureStorage();

Future<void> saveTokens(String accessToken, String refreshToken) async {
  await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
  await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
}
