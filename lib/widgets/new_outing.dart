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
  static final DateTime rightNow = DateTime.now();
  DateTime _startDate = rightNow;
  String _startDateString = new DateFormat.yMd().add_jm().format(rightNow);

  Future<TimeOfDay> _selectTime(
    BuildContext context,
    DateTime startTimeAsDate,
  ) async {
    final TimeOfDay startTime = TimeOfDay.fromDateTime(
      startTimeAsDate,
    );
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    return pickedTime != null ? pickedTime : startTime;
  }

  Future<DateTime> _selectDate(
    BuildContext context,
    DateTime selector,
  ) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selector,
      firstDate: rightNow,
      lastDate: DateTime(2101),
    );
    return picked != null ? picked : selector;
  }

  @override
  Widget build(BuildContext context) {
    final OutingArguments args = ModalRoute.of(context).settings.arguments;

    return Container(
        child: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Type: ${args.isAuto ? 'Auto' : 'Interval'}',
                textScaleFactor: 2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                  color: appTheme.buttonColor,
                  textColor: appTheme.primaryTextTheme.body1.color,
                  onPressed: () async {
                    DateTime newDate = await _selectDate(context, _startDate);
                    TimeOfDay newTime = await _selectTime(context, newDate);
                    newDate = new DateTime(
                      newDate.year,
                      newDate.month,
                      newDate.day,
                      newTime.hour,
                      newTime.minute,
                    );
                    setState(() {
                      _startDate = newDate;
                      _startDateString =
                          new DateFormat.yMd().add_jm().format(_startDate);
                    });
                  },
                  child: Text(_startDateString)),
            ],
          ),
        ],
      ),
    ));
  }
}
