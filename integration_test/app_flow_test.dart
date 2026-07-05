import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shareme/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End Handshake Flow Validation', (WidgetTester tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    final grantButton = find.text('Grant Permissions');
    if (grantButton.evaluate().isNotEmpty) {
      await tester.tap(grantButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    // Verify we are on Home Screen
    expect(find.text('RECEIVE'), findsOneWidget);
    
    // Tap RECEIVE to go to radar screen
    await tester.tap(find.text('RECEIVE'));
    await tester.pumpAndSettle();

    expect(find.text('Nearby Devices'), findsOneWidget);
  });
}
