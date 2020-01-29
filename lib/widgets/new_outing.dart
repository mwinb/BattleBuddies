import 'package:battle_buddies/utilities/date_time_functions.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class OutingArguments {
  bool isAuto;
  OutingArguments(this.isAuto);
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
  DateTime _startDate = DateTime.now();
  String _startDateString =
      new DateFormat.yMd().add_jm().format(DateTime.now());
  Contact _chosenContact;

  @override
  Widget build(BuildContext context) {
    final OutingArguments args = ModalRoute.of(context).settings.arguments;
    Duration maxDuration = new Duration(days: 1);
    DateTime maxDate = DateTime.now().add(maxDuration);

    return Table(
      children: [
        TableRow(children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            child: Center(
                child: Text(
              '${args.isAuto ? 'Auto Check In' : 'Manual Check In'}',
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
                  label: Text(_startDateString),
                  icon: new Tooltip(
                      message: 'select end date',
                      child: Icon(
                        Icons.date_range,
                        semanticLabel: 'Choose End Time',
                      )),
                  onPressed: () async {
                    DateTime newDate = await selectDate(
                      context,
                      _startDate,
                      maxCalendarDate: maxDate,
                    );
                    TimeOfDay newTime = await selectTime(
                      context,
                      newDate,
                    );
                    newDate = getDateTimeFromDateAndTime(
                      newDate,
                      newTime,
                    );
                    setState(() {
                      _startDate = newDate;
                      _startDateString =
                          new DateFormat.yMd().add_jm().format(_startDate);
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
                FlatButton.icon(
                  color: appTheme.buttonColor,
                  label: Text('Select Contact'),
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
      ],
    );
  }
}
