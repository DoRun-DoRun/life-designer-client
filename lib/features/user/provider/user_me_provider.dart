import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../common/constant/data.dart';
import '../../../common/secure_storage/secure_storage.dart';
import '../model/user_model.dart';
import '../repository/auth_repository.dart';
import '../repository/user_me_repository.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userMeRepository = ref.watch(userMeRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);

    return UserMeStateNotifier(
      authRepository: authRepository,
      repository: userMeRepository,
      storage: storage,
    );
  },
);

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

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

    // TODO: Must Remove after Testing
    if (accessToken == 'dummy_access_token' &&
        refreshToken == 'dummy_refresh_token') {
      final dummyUser = UserModel(
        id: '1',
        username: 'test',
        imageUrl: '/asset/images/character/bear-example.png',
      );
      state = dummyUser;
      return;
    }

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final resp = await repository.getMe();

    state = resp;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      // TODO: Must Remove after Testing
      if (username == 'test@test.com' && password == 't12345') {
        const dummyAccessToken = 'dummy_access_token';
        const dummyRefreshToken = 'dummy_refresh_token';

        await storage.write(key: REFRESH_TOKEN_KEY, value: dummyRefreshToken);
        await storage.write(key: ACCESS_TOKEN_KEY, value: dummyAccessToken);

        final userResp = UserModel(
          id: '1',
          username: 'test',
          imageUrl: '/asset/images/character/bear-example.png',
        );

        state = userResp;
        return userResp;
      }

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await repository.getMe();

      state = userResp;

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');

      return Future.value(state);
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
}
