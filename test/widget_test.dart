import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subtrack/app.dart';

void main() {
  testWidgets('App renders SubTrack title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SubTrackApp(),
      ),
    );

    expect(find.text('SubTrack'), findsWidgets);
  });
}
