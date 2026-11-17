import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:subtrack/app.dart';
import 'package:subtrack/core/router/app_router.dart';
import 'package:subtrack/core/theme/theme_provider.dart';

void main() {
  testWidgets('Renders app shell with NavigationBar tabs and navigates correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SubTrackApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Home tab is initially active
    expect(find.text('SubTrack'), findsWidgets);
    expect(find.text('Your Subscriptions'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Switch to Analytics tab
    await tester.tap(find.text('Analytics'));
    await tester.pumpAndSettle();

    expect(find.text('Annual Forecast'), findsOneWidget);
    expect(find.text('Spending by Category'), findsOneWidget);

    // Switch to Settings tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Theme Mode'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
  });

  testWidgets('themeModeProvider updates state correctly', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Default is ThemeMode.system
    expect(container.read(themeModeProvider), ThemeMode.system);

    // Change to Dark
    container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
    expect(container.read(themeModeProvider), ThemeMode.dark);

    // Change to Light
    container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
    expect(container.read(themeModeProvider), ThemeMode.light);

    // Toggle back to Dark
    container.read(themeModeProvider.notifier).toggleTheme();
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  testWidgets('Navigates to /subscriptions/add, :id, and :id/edit', (
    WidgetTester tester,
  ) async {
    late WidgetRef capturedRef;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            capturedRef = ref;
            return const SubTrackApp();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final router = capturedRef.read(routerProvider);

    // Navigate to /subscriptions/add
    router.go('/subscriptions/add');
    await tester.pumpAndSettle();
    expect(find.text('Add Subscription'), findsOneWidget);
    expect(find.text('Save Subscription'), findsOneWidget);

    // Navigate to /subscriptions/:id
    router.go('/subscriptions/netflix-4k');
    await tester.pumpAndSettle();
    expect(find.text('Subscription Details'), findsOneWidget);
    expect(find.text('ID: netflix-4k'), findsOneWidget);

    // Navigate to /subscriptions/:id/edit
    router.go('/subscriptions/netflix-4k/edit');
    await tester.pumpAndSettle();
    expect(find.text('Edit Subscription'), findsOneWidget);
    expect(find.text('Editing: netflix-4k'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });
}
