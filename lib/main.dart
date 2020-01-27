import 'package:battle_buddies/widgets/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(BattleBuddies());

ThemeData appTheme = ThemeData.dark();

class BattleBuddies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battle Buddies',
      theme: appTheme,
      home: HomePage(title: 'Battle Buddies'),
    );
  }
}
