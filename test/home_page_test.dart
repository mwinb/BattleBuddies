import 'package:battle_buddies/main.dart';
import 'package:battle_buddies/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Executes Alert Dialog When Clicking Button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      BattleBuddies(),
    );

    expect(find.text('New Outing'), findsOneWidget);

    await tester.tap(find.text(HomeStrings().buttonNewOuting));
    await tester.pump();

    expect(find.text(HomeStrings().buttonAuto), findsOneWidget);
    expect(find.text(HomeStrings().buttonCheckIn), findsOneWidget);
  });

  testWidgets('Closes Alert Dialog When Clicking Continue',
      (WidgetTester tester) async {
    await tester.pumpWidget(BattleBuddies());
    // Open Dialog
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();
    // Click closeDialog button.
    await tester.tap(find.text(HomeStrings().buttonCheckIn));
    await tester.pump();

    expect(find.text(HomeStrings().titleSelectType), findsNothing);
  });
}
