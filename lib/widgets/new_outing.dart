import 'package:battle_buddies/models/outing.dart';
import 'package:battle_buddies/outing_db_helper.dart';
import 'package:battle_buddies/widgets/current_outing.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class OutingType {
  bool isAuto;
  OutingType(this.isAuto);
}

class NewOuting extends StatefulWidget {
  const NewOuting({Key key}) : super(key: key);
  static const routeName = '/NewOuting';
  @override
  State<StatefulWidget> createState() {
    return _NewOutingState();
  }
}

class _NewOutingState extends State<NewOuting> {
  final ContactPicker _contactPicker = new ContactPicker();

  DateTime _endDate;
  Contact _chosenContact;
  Duration _checkinInterval = new Duration(minutes: 30);

  @override
  Widget build(BuildContext context) {
    OutingType args = ModalRoute.of(context).settings.arguments;
    if (args == null) {
      Navigator.popAndPushNamed(
        context,
        '/',
      );
    }
    final Duration minDuration = new Duration(seconds: 30);
    final Duration maxTimerDays = new Duration(days: 2);
    DateTime maxDate = DateTime.now().add(maxTimerDays);

    bool isValid() {
      return _chosenContact != null &&
          _chosenContact.phoneNumber != null &&
          _endDate != null;
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
              '${args.isAuto ? 'Auto Check In' : 'Manual Check In'}',
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
                    'Select Event Ending',
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
                FlatButton.icon(
                  color: appTheme.buttonColor,
                  label: Text(_endDate == null
                      ? new DateFormat.yMd().add_jm().format(DateTime.now())
                      : new DateFormat.yMd().add_jm().format(_endDate)),
                  icon: new Tooltip(
                      message: 'select end date',
                      child: Icon(
                        Icons.date_range,
                        semanticLabel: 'Choose End Time',
                      )),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                              height: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height /
                                  3,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.dateAndTime,
                                minimumDate: new DateTime.now(),
                                maximumDate: maxDate,
                                initialDateTime: new DateTime.now(),
                                onDateTimeChanged: (DateTime selectedDate) {
                                  setState(() {
                                    _endDate = selectedDate;
                                  });
                                },
                              ));
                        });
                  },
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
                    'Select Check In Interval',
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
                FlatButton.icon(
                  color: appTheme.buttonColor,
                  label: Text(_checkinInterval.toString().split('.')[0]),
                  icon: new Tooltip(
                      message: 'Select Contact',
                      child: Icon(
                        Icons.timer,
                        semanticLabel: 'Choose Contact',
                      )),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: CupertinoTimerPicker(
                              mode: CupertinoTimerPickerMode.hms,
                              minuteInterval: 15,
                              secondInterval: 30,
                              initialTimerDuration: _checkinInterval,
                              onTimerDurationChanged: (Duration changedtimer) {
                                setState(() {
                                  if (changedtimer >= minDuration)
                                    _checkinInterval = changedtimer;
                                });
                              },
                            ),
                          );
                        });
                  },
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
                    'Select Contact',
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
                FlatButton.icon(
                  color: appTheme.buttonColor,
                  label: Text(_chosenContact == null
                      ? 'Choose Contact'
                      : _chosenContact.fullName),
                  icon: new Tooltip(
                      message: 'Select Contact',
                      child: Icon(
                        Icons.contacts,
                        semanticLabel: 'Choose Contact',
                      )),
                  onPressed: () async {
                    Contact contact = await _contactPicker.selectContact();
                    setState(() {
                      if (contact != null) {
                        _chosenContact = contact;
                      }
                    });
                  },
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
                  color: appTheme.buttonColor,
                  label: Text('Start Outing'),
                  onPressed: () async {
                    if (isValid()) {
                      var totalTime = DateTime.now().difference(_endDate).abs();
                      var checkInInterval =
                          _checkinInterval.compareTo(totalTime) > 0
                              ? totalTime
                              : _checkinInterval;
                      var dbHelper = new OutingDBHelper();
                      await dbHelper.insert(Outing(args.isAuto, DateTime.now(),
                          _endDate, checkInInterval, _chosenContact));

                      Navigator.pushNamedAndRemoveUntil(
                          context, CurrentOuting.routeName, (r) => false,
                          arguments: Outing(args.isAuto, DateTime.now(),
                              _endDate, checkInInterval, _chosenContact));
                    }
                  },
                  icon: new Tooltip(
                      message: 'start outing',
                      child: Icon(
                        Icons.save,
                        semanticLabel: 'Start Outing',
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
