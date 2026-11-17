import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:subtrack/core/router/scaffold_with_nav_bar.dart';
import 'package:subtrack/features/analytics/analytics_screen.dart';
import 'package:subtrack/features/home/home_screen.dart';
import 'package:subtrack/features/settings/settings_screen.dart';
import 'package:subtrack/features/subscriptions/add_subscription_screen.dart';
import 'package:subtrack/features/subscriptions/edit_subscription_screen.dart';
import 'package:subtrack/features/subscriptions/subscription_detail_screen.dart';

/// Global root navigator key
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Riverpod provider exposing the configured [GoRouter]
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Bottom navigation shell with three tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Branch 2: Analytics
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),

          // Branch 3: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Route: /subscriptions/add
      GoRoute(
        path: '/subscriptions/add',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AddSubscriptionScreen(),
      ),

      // Route: /subscriptions/:id and /subscriptions/:id/edit
      GoRoute(
        path: '/subscriptions/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SubscriptionDetailScreen(id: id);
        },
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return EditSubscriptionScreen(id: id);
            },
          ),
        ],
      ),
    ],
  );
});
