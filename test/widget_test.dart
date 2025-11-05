import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:f1/main.dart';

void main() {
  testWidgets('Registration screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RegistrationApp());

    // Verify that "Register" text appears on screen.
    expect(find.text('Register'), findsOneWidget);

    // Verify that the Register button exists.
    expect(find.text('Register'), findsWidgets); // header + button

    // Fill text fields and tap the button
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');

    await tester.tap(find.text('Register').last); // tap button
    await tester.pump(); // rebuild

    // Verify SnackBar shows success message
    expect(find.text('✅ Registered Successfully!'), findsOneWidget);
  });
}
