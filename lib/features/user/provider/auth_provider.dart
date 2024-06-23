import 'package:dorun_app_flutter/features/routine/view/routine_create_progress_screen.dart';
import 'package:dorun_app_flutter/features/routine/view/routine_create_screen.dart';
import 'package:dorun_app_flutter/features/routine/view/routine_detail_screen.dart';
import 'package:dorun_app_flutter/features/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constant/data.dart';
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
          path: '/routine_create',
          name: RoutineCreateScreen.routeName,
          builder: (_, state) => const RoutineCreateScreen(),
          routes: [
            GoRoute(
              path: 'routine_create_progress',
              name: RoutineCreateProgressScreen.routeName,
              builder: (_, state) {
                // state.extra에 대한 null 체크와 기본값 처리
                final args = state.extra as Map<String, dynamic>? ?? {};
                return RoutineCreateProgressScreen(
                  routineGoal: args['routineGoal'] as String? ?? 'Default Goal',
                  startTime: args['startTime'] as TimeOfDay? ?? TimeOfDay.now(),
                  repeatCycle: args['repeatCycle'] as RepeatCycle? ?? RepeatCycle.daily,
                  weekDays: args['weekDays'] as List<bool>? ?? List.filled(7, false),
                  alertTime: args['alertTime'] as String? ?? 'No Alert',
                );
              },
            ),
          ],
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
      print('Step 1');
      return logginIn ? null : '/login';
    }

    if (user is UserModel) {
      print('Step 2');
      return logginIn || state.matchedLocation == '/splash' ? '/' : null;
    }

    if (user is UserModelError) {
      print('Step 3');
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
