import 'package:battle_buddies/widgets/current_outing.dart';
import 'package:battle_buddies/widgets/home_page.dart';
import 'package:battle_buddies/widgets/new_outing.dart';
import 'package:flutter/material.dart';

main() async {
  runApp(BattleBuddies());
}

ThemeData appTheme = ThemeData.light();

class BattleBuddies extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BattleBuddiesState();
  }
}

class _BattleBuddiesState extends State<BattleBuddies> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Battle Buddies',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          HomePage.routeName: (context) => AppScaffold(
                body: HomePage(),
              ),
          NewOuting.routeName: (context) => AppScaffold(body: NewOuting()),
          CurrentOuting.routeName: (context) =>
              AppScaffold(body: CurrentOuting()),
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
