import 'package:battle_buddies/utilities/date_time_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date Time Functions', () {
    test('it converts a date and a time to a date time', () {
      var testDate = new DateTime(2019);
      var testTimeOfDay = new TimeOfDay.fromDateTime(testDate.add(new Duration(
        hours: 6,
        minutes: 10,
      )));

      var result = getDateTimeFromDateAndTime(
        testDate,
        testTimeOfDay,
      );
      expect(result.day, testDate.day);
      expect(result.hour, testTimeOfDay.hour);
      expect(result.minute, testTimeOfDay.minute);
    });
  });
}
