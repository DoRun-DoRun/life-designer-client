import 'dart:io' show Platform;

import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/secure_storage/secure_storage.dart';
import 'package:dorun_app_flutter/features/user/provider/user_me_provider.dart';
import 'package:dorun_app_flutter/features/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

import '../../../common/layout/default_layout.dart';

String? decodeAndExtractEmail(String identityToken) {
  try {
    // identityToken을 디코드
    Map<String, dynamic> decodedToken = JwtDecoder.decode(identityToken);

    // 이메일 정보 추출
    String? email = decodedToken['email'];

    if (email != null) {
      return email;
    }
  } catch (error) {
    print('Failed to decode JWT: $error');
  }
  return null;
}

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final userRepository = ref.watch(userRepositoryProvider);

    void login(email, String authProvider) async {
      try {
        final tokens = await userRepository.login(
          email: email,
          authProvider: authProvider,
        );
        await saveTokens(tokens.accessToken, tokens.refreshToken);
        ref.read(userMeProvider.notifier).getMe();
      } catch (error) {
        if (mounted) {
          print('로그인 실패: ${error.toString()}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('로그인 실패: ${error.toString()}'),
            ),
          );
        } else {
          print('로그인 실패: ${error.toString()}');
        }
      }
    }

    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    GoogleSignIn googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: 'your-client_id.apps.googleusercontent.com',
      scopes: scopes,
    );

    Future<void> handleSignIn() async {
      try {
        await googleSignIn.signIn();
        login(googleSignIn.currentUser?.email, "Google");
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('로그인 실패: ${error.toString()}'),
            ),
          );
        } else {
          print('로그인 실패: ${error.toString()}');
        }
      }
    }

    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const PaddingContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('당신의 삶을 설계하는\n맞춤형 라이프 디자이너,\n라디에 오신걸 환영합니다!',
                      style: AppTextStyles.BOLD_20),
                  SizedBox(height: 16.0),
                  Text('5초 가입으로 좋은 습관들을 만들어보세요',
                      style: AppTextStyles.MEDIUM_14),
                  SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: GapColumn(
              gap: 24,
              children: [
                GestureDetector(
                    onTap: () async {
                      if (await isKakaoTalkInstalled()) {
                        try {
                          await UserApi.instance.loginWithKakaoTalk();
                          User user = await UserApi.instance.me();
                          login(user.kakaoAccount?.email, "Kakao");

                          // print('카카오톡으로 로그인 성공 $user');
                        } catch (error) {
                          print('카카오톡으로 로그인 실패 $error');
                        }
                      } else {
                        try {
                          await UserApi.instance.loginWithKakaoAccount();
                          User user = await UserApi.instance.me();

                          // print('카카오계정으로 로그인 성공 $user');
                          login(user.kakaoAccount?.email, "Kakao");
                        } catch (error) {
                          print('카카오계정으로 로그인 실패 $error');
                        }
                      }
                    },
                    child: const LoginButton(socialType: SocialType.kakao)),
                GestureDetector(
                    onTap: handleSignIn,
                    child: const LoginButton(socialType: SocialType.google)),
                Platform.isIOS
                    ? GestureDetector(
                        onTap: () {
                          SignInWithApple.getAppleIDCredential(
                            scopes: [AppleIDAuthorizationScopes.email],
                          ).then((AuthorizationCredentialAppleID user) {
                            print(user.identityToken);

                            if (user.email != null) {
                              login(user.email, "Apple");
                            } else if (user.identityToken != null) {
                              login(
                                decodeAndExtractEmail(user.identityToken!),
                                "Apple",
                              );
                            }
                            // 로그인 후 로직
                          }).onError((error, stackTrace) {
                            if (error is PlatformException) return;
                            print(error);
                          });
                        },
                        child: const LoginButton(socialType: SocialType.apple))
                    : Container(),
                GestureDetector(
                  onTap: () async {
                    String? storedUUID = await getUUID();

                    if (storedUUID == null) {
                      var uuid = const Uuid();
                      String newUUID = uuid.v4();

                      await saveUUID(newUUID);

                      login(newUUID, 'Guest');
                    } else {
                      login(storedUUID, 'Guest');
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text(
                        "Guest로 계속하기",
                        style: AppTextStyles.MEDIUM_14.copyWith(
                          color: AppColors.TEXT_SECONDARY,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum SocialType {
  kakao,
  google,
  apple,
}

class LoginButton extends StatelessWidget {
  final SocialType socialType;

  const LoginButton({
    super.key,
    required this.socialType,
  });

  @override
  Widget build(BuildContext context) {
    String text, image;
    // Image image;
    Color color;

    switch (socialType) {
      case SocialType.kakao:
        text = 'Kakao로 계속하기';
        image = 'kakao';
        color = const Color(0xFFFEE500);
        break;
      case SocialType.google:
        text = 'Google로 계속하기';
        image = 'google';
        color = const Color(0xFFFFFFFF);
        break;
      case SocialType.apple:
        text = 'Apple로 계속하기';
        image = 'apple';
        color = const Color(0xFF0A0A0A);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      decoration:
          BoxDecoration(color: color, borderRadius: AppRadius.ROUNDED_4),
      child: Row(
        children: [
          Image.asset('asset/images/$image.png', width: 24, height: 24),
          Expanded(
            child: Center(
              child: Text(
                text,
                style: AppTextStyles.MEDIUM_14.copyWith(
                    color: socialType == SocialType.apple
                        ? Colors.white
                        : const Color.fromRGBO(0, 0, 0, .85)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
