import 'package:battle_buddies/main.dart';
import 'package:battle_buddies/models/outing.dart';
import 'package:battle_buddies/outing_db_helper.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'current_outing.dart';
import 'new_outing.dart';

class HomeStrings {
  get titleSelectType => 'Choose Interval Type';
  get buttonAuto => 'Auto';
  get buttonCheckIn => 'Check In';
  get buttonNewOuting => 'New Outing';
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  static const routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Outing outing;
  HomeStrings _homeStrings = HomeStrings();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _populateOutings();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(backgroundColor: Colors.blue));
    } else {
      return Container(
        alignment: Alignment.center,
        child: MaterialButton(
            color: appTheme.buttonColor,
            onPressed: () => _selectEventType(context, _homeStrings),
            child: Text(_homeStrings.buttonNewOuting)),
      );
    }
  }

  Future<void> _populateOutings() async {
    var dbInstance = new OutingDBHelper();
    var outings = await dbInstance.queryAllRows();
    if (outings.length > 0) {
      var outing = outings[0];
      if (DateTime.now().compareTo(outing.endDate) >= 0) {
        await dbInstance.delete(outing.id);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, CurrentOuting.routeName, (r) => false,
            arguments: outing);
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}

Future<void> _selectEventType(
    BuildContext context, HomeStrings _homeStrings) async {
  return showDialog<void>(
    context: context,
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
                    child: Text(_homeStrings.buttonAuto),
                    onPressed: () {
                      Navigator.popAndPushNamed(
                        context,
                        NewOuting.routeName,
                        arguments: OutingType(true),
                      );
                    },
                  ),
                  MaterialButton(
                    color: appTheme.buttonColor,
                    child: Text(_homeStrings.buttonCheckIn),
                    onPressed: () {
                      Navigator.popAndPushNamed(
                        context,
                        NewOuting.routeName,
                        arguments: OutingType(false),
                      );
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
