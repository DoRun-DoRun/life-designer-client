import 'package:dorun_app_flutter/features/routine/view/routine_detail_screen.dart';
import 'package:dorun_app_flutter/features/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/view/root_tab.dart';
import '../model/user_model.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
        ),
        GoRoute(
          path: '/routine_detail/:id',
          name: RoutineDetailScreen.routeName,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return RoutineDetailScreen(id: int.parse(id));
          },
        ),
      ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.matchedLocation == '/login';

    if (user == null) {
      return logginIn ? null : '/login';
    }

    if (user is UserModel) {
      return logginIn || state.matchedLocation == '/splash' ? '/' : null;
    }

    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
