import 'package:dio/dio.dart' hide Headers;
import 'package:dorun_app_flutter/features/user/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../../common/constant/data.dart';
import '../../../common/dio/dio.dart';
import '../model/login_response_model.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return UserRepository(dio, baseUrl: 'http://$ip/users');
  },
);

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @POST('/')
  Future<LoginResponseModel> login({
    @Field('email') required String email,
    @Field('authProvider') required String authProvider,
  });

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  @PUT('/')
  @Headers({'accessToken': 'true'})
  Future<void> updateUser({
    @Field('name') String? name,
    @Field('age') String? age,
    @Field('job') String? job,
    @Field('challenges') List<String>? challenges,
    @Field('gender') String? gender,
    @Field('memberStatus') String? memberStatus,
  });

  @PUT('/withdraw')
  @Headers({'accessToken': 'true'})
  Future<void> deleteUser();
}
