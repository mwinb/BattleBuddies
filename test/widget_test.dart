import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:battle_buddies/widgets/main.dart';

void main() {
  const buttonText = 'New Outing';
  const alertText = 'Coming Soon';
  const closeDialog = 'Check In';
  testWidgets('Executes Alert Dialog When Clicking Button',
      (WidgetTester tester) async {
    await tester.pumpWidget(BattleBuddies());

    expect(find.text(buttonText), findsOneWidget);

    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    expect(find.text(alertText), findsOneWidget);
  });

  testWidgets('Closes Alert Dialog When Clicking Continue',
      (WidgetTester tester) async {
    await tester.pumpWidget(BattleBuddies());
    // Open Dialog
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();
    // Click closeDialog button.
    await tester.tap(find.text(closeDialog));
    await tester.pump();

    expect(find.text(alertText), findsNothing);
  });
}
