import 'package:battle_buddies/utilities/date_time_functions.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _UsNumberTextInputFormatter _phoneNumberFormatter =
      _UsNumberTextInputFormatter();

  final ContactPicker _contactPicker = new ContactPicker();
  DateTime _startDate = DateTime.now();
  String _startDateString =
      new DateFormat.yMd().add_jm().format(DateTime.now());
  String _phoneNumber;
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
          Padding(
              padding: EdgeInsets.only(top: 10, left: 100, right: 100),
              child: TextField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  hintText: 'Enter contact to alert if you dont check in.',
                  labelText: 'Phone Number *',
                  prefixText: '+1',
                ),
                maxLengthEnforced: true,
                maxLength: 14,
                keyboardType: TextInputType.phone,
                onChanged: (String value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  _phoneNumberFormatter,
                ],
              )),
        ]),
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  color: appTheme.buttonColor,
                  label: Text('Start Outing'),
                  onPressed: () {
                    Navigator.popAndPushNamed(
                      context,
                      '/',
                    );
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
        // TableRow(children: [
        //   TableCell(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         FlatButton.icon(
        //           color: appTheme.buttonColor,
        //           label: Text(
        //               _phoneNumber == null ? 'Choose Contact' : _phoneNumber),
        //           icon: new Tooltip(
        //               message: 'Select Contact',
        //               child: Icon(
        //                 Icons.contacts,
        //                 semanticLabel: 'Choose Contact',
        //               )),
        //           onPressed: () async {
        //             Contact contact = await _contactPicker.selectContact();
        //             setState(() {
        //               if (contact != null) {
        //                 _chosenContact = contact;
        //               }
        //             });
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ]),
      ],
    );
  }
}

// source: https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/text_form_field_demo.dart#L297-L335
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
