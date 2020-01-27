import 'package:battle_buddies/widgets/home_page.dart';
import 'package:battle_buddies/widgets/new_outing.dart';
import 'package:flutter/material.dart';

void main() => runApp(BattleBuddies());

ThemeData appTheme = ThemeData.dark();

class BattleBuddies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Battle Buddies',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          HomePage.routeName: (context) => AppScaffold(body: HomePage()),
          NewOuting.routeName: (context) => AppScaffold(body: NewOuting()),
        });
  }
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({Key key, this.body}) : super(key: key);
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battle Buddies'),
      ),
      body: body,
    );
  }
}
