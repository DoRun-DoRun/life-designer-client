import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider =
    Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

const ACCESS_TOKEN_KEY = 'accessToken';
const REFRESH_TOKEN_KEY = 'refreshToken';
const UUID_KEY = 'deviceUUID';

// Secure storage instance
const storage = FlutterSecureStorage();

Future<void> saveTokens(String accessToken, String refreshToken) async {
  await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
  await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
}

// UUID를 저장하는 함수
Future<void> saveUUID(String uuid) async {
  await storage.write(key: UUID_KEY, value: uuid);
}

// UUID를 가져오는 함수 (존재하지 않을 경우 null 반환)
Future<String?> getUUID() async {
  return await storage.read(key: UUID_KEY);
}
