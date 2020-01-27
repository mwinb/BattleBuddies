import 'package:battle_buddies/main.dart';
import 'package:flutter/material.dart';

class HomeStrings {
  get titleSelectType => 'Choose Interval Type';
  get buttonAuto => 'Auto';
  get buttonCheckIn => 'Check In';
  get buttonNewOuting => 'New Outing';
}

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  final HomeStrings _homeStrings = HomeStrings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
                color: appTheme.buttonColor,
                textColor: appTheme.primaryTextTheme.body1.color,
                onPressed: () => _selectEventType(context, _homeStrings),
                child: Text(_homeStrings.buttonNewOuting)),
          ],
        ),
      ),
    );
  }
}

Future<void> _selectEventType(
    BuildContext context, HomeStrings _homeStrings) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          _homeStrings.titleSelectType,
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    color: appTheme.buttonColor,
                    textColor: appTheme.primaryTextTheme.body1.color,
                    child: Text(_homeStrings.buttonAuto),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  MaterialButton(
                    color: appTheme.buttonColor,
                    textColor: appTheme.primaryTextTheme.body1.color,
                    child: Text(_homeStrings.buttonCheckIn),
                    onPressed: () {
                      Navigator.pop(context);
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
