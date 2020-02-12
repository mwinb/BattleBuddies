import 'dart:async';

import 'package:battle_buddies/models/outing.dart';
import 'package:battle_buddies/outing_db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

Future<void> checkOuting(BuildContext context) async {
  var dbInstance = new OutingDBHelper();
  var outings = await dbInstance.queryAllRows();
  if (outings.length > 0) {
    if (DateTime.now().compareTo(outings[0].endDate) >= 0) {
      await dbInstance.delete(outings[0].id);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (r) => false,
      );
    }
  }
}

class CurrentOuting extends StatefulWidget {
  CurrentOuting({Key key}) : super(key: key);
  static const routeName = '/CurrentOuting';

  @override
  _CurrentOutingState createState() => _CurrentOutingState();
}

class _CurrentOutingState extends State<CurrentOuting> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(
        new Duration(seconds: 30), (Timer t) => checkOuting(context));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Outing args = ModalRoute.of(context).settings.arguments;

    if (args == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (r) => false,
      );
    }

    return Table(
      children: [
        TableRow(children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            child: Center(
                child: Text(
              'Current Outing: ${args.outingTypeString}',
              style: TextStyle(color: Colors.white),
              textScaleFactor: 1.5,
            )),
          ),
        ]),
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Text(
                    'End Date',
                    textScaleFactor: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ]),
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: Text(
                    new DateFormat.yMd().add_jm().format(args.endDate),
                    textScaleFactor: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ]),
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Text(
                    'Interval',
                    textScaleFactor: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ]),
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: Text(
                    args.checkInInterval.toString().split('.')[0],
                    textScaleFactor: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ]),
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Text(
                    'Chosen Contact',
                    textScaleFactor: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ]),
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: Text(
                    args.contact.fullName,
                    textScaleFactor: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ]),
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: Text(
                    args.contact.phoneNumber.toString(),
                    textScaleFactor: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ]),
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 150.0,
                  ),
                ),
                FlatButton.icon(
                  color: Colors.red,
                  label: Text('Cancel Outing'),
                  onPressed: () async {
                    var db = new OutingDBHelper();
                    await db.delete(args.id);
                    Navigator.popAndPushNamed(context, '/');
                  },
                  icon: new Tooltip(
                      message: 'cancel outing',
                      child: Icon(
                        Icons.save,
                        semanticLabel: 'Cancel Outing',
                      )),
                ),
              ],
            ),
          ),
        ]),
      ],
    );
  }
}
