import 'package:contact_picker/contact_picker.dart';

class Outing {
  int id = 0;
  bool isAuto;
  bool hasAlarm = false;
  DateTime startDate;
  DateTime endDate;
  Duration checkInInterval;
  Contact contact;

  Outing(this.isAuto, this.startDate, this.endDate, this.checkInInterval,
      this.contact);

  Outing.fromDbMap(Map<String, dynamic> dbMap) {
    this.isAuto = dbMap['is_auto'] == 'Auto' ? true : false;
    this.startDate = DateTime.parse(dbMap['start_date']);
    this.endDate = DateTime.parse(dbMap['end_date']);
    this.hasAlarm = dbMap['has_alarm'] == 'false' ? false : true;
    this.checkInInterval = new Duration(seconds: dbMap['check_in_interval']);
    this.contact = new Contact(
        fullName: dbMap['contact_name'],
        phoneNumber: new PhoneNumber(number: dbMap['contact_number']));
  }

  setAlarm() {
    this.hasAlarm = true;
  }

  cancelAlarm() {
    this.hasAlarm = false;
  }

  get outingTypeString {
    return isAuto ? 'Auto' : 'Manual';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_auto': this.outingTypeString,
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
      'check_in_interval': checkInInterval.inSeconds,
      'contact_name': contact.fullName,
      'contact_number': contact.phoneNumber.number,
      'has_alarm': this.hasAlarm.toString(),
    };
  }
}
