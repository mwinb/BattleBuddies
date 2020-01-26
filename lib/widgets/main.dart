import 'package:flutter/material.dart';

void main() => runApp(BattleBuddies());

class BattleBuddies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battle Buddies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonColor: Colors.blue,
        primaryTextTheme: Typography.whiteMountainView,
      ),
      home: MyHomePage(title: 'Battle Buddies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
                color: Theme.of(context).buttonColor,
                textColor: Theme.of(context).primaryTextTheme.body1.color,
                onPressed: () => _comingSoonAlert(this.context),
                child: Text('New Outing')),
          ],
        ),
      ),
    );
  }
}

Future<void> _comingSoonAlert(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Choose Interval Type',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    color: Theme.of(context).buttonColor,
                    textColor: Theme.of(context).primaryTextTheme.body1.color,
                    child: Text('Auto'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Theme.of(context).buttonColor,
                    textColor: Theme.of(context).primaryTextTheme.body1.color,
                    child: Text('Check In'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
