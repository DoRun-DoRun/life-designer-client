import 'package:dorun_app_flutter/features/user/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../common/secure_storage/secure_storage.dart';
import '../model/user_model.dart';
import '../repository/auth_repository.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userRepository = ref.watch(userRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);

    return UserMeStateNotifier(
      authRepository: authRepository,
      repository: userRepository,
      storage: storage,
    );
  },
);

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserRepository repository;
  final FlutterSecureStorage storage;

  @override
  set state(UserModelBase? value) {
    print('State is changing to: $value');
    super.state = value;
  }

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    print("GET ME");

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    print(
        'Tokens found: refreshToken = $refreshToken, accessToken = $accessToken');

    try {
      final resp = await repository.getMe();
      print('User data fetched successfully: $resp');
      state = resp;
    } catch (error) {
      print('Error fetching user data: $error');
      state = null;
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait(
      [
        storage.delete(key: REFRESH_TOKEN_KEY),
        storage.delete(key: ACCESS_TOKEN_KEY),
      ],
    );
  }

  Future<void> signOut() async {
    try {
      await repository.deleteUser();

      state = null;
      // TODO
      // 기타 캐시 invalidate 처리하기

      await Future.wait(
        [
          storage.delete(key: REFRESH_TOKEN_KEY),
          storage.delete(key: ACCESS_TOKEN_KEY),
        ],
      );
    } catch (error) {
      print('Error fetching user data: $error');
      state = null;
    }
  }
}
