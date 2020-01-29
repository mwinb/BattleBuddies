import 'package:battle_buddies/main.dart';
import 'package:battle_buddies/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  HomeStrings _widgetStrings = HomeStrings();

  testWidgets(
      'Executes Alert Dialog When Clicking ${HomeStrings().buttonNewOuting}',
      (WidgetTester tester) async {
    await tester.pumpWidget(BattleBuddies());

    expect(find.text(_widgetStrings.buttonNewOuting), findsOneWidget);

    await tester.tap(find.text(_widgetStrings.buttonNewOuting));
    await tester.pump();

    expect(find.text(_widgetStrings.buttonAuto), findsOneWidget);
    expect(find.text(_widgetStrings.buttonCheckIn), findsOneWidget);
  });

  testWidgets(
      'Closes Alert Dialog When Clicking ${HomeStrings().buttonCheckIn}',
      (WidgetTester tester) async {
    await tester.pumpWidget(BattleBuddies());
    // Open Dialog
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();
    // Click closeDialog button.
    await tester.tap(find.text(_widgetStrings.buttonCheckIn));
    await tester.pump();

    expect(find.text(_widgetStrings.titleSelectType), findsNothing);
  });
}
