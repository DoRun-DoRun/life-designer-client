import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutineReviewScreen extends StatelessWidget {
  static String get routeName => 'routinReviewScreen';
  final int id;
  const RoutineReviewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      rightIcon: IconButton(
        icon: const Icon(Icons.close, size: 30),
        onPressed: () {
          context.go('/');
        },
      ),
      child: const Placeholder(),
    );
  }
}
