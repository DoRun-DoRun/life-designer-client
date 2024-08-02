import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../../common/constant/data.dart';
import '../../../common/dio/dio.dart';
import '../model/user_model.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
  },
);

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();
}
