import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay> selectTime(
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

Future<DateTime> selectDate(
  BuildContext context,
  DateTime initialDate, {
  DateTime minCalendarDate,
  DateTime maxCalendarDate,
}) async {
  var minDate = minCalendarDate != null
      ? minCalendarDate
      : new DateTime.now().subtract(new Duration(days: 1));
  var maxDate = maxCalendarDate != null
      ? maxCalendarDate
      : DateTime.now().add(new Duration(days: 100 * 365));
  final DateTime picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: minDate,
    lastDate: maxDate,
  );
  return picked != null ? picked : initialDate;
}

DateTime getDateTimeFromDateAndTime(DateTime date, TimeOfDay time) {
  return new DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
    0,
    0,
  );
}
