import 'dart:async';
import 'dart:ui';
import 'package:battle_buddies/models/geo_locator_helper.dart';
import 'package:battle_buddies/models/outing.dart';
import 'package:battle_buddies/outing_db_helper.dart';
import 'package:battle_buddies/models/local_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';

import '../main.dart';

const String channelId = 'Battle Buddies';

class CurrentOuting extends StatefulWidget {
  CurrentOuting({Key key}) : super(key: key);
  static const routeName = '/CurrentOuting';

  @override
  _CurrentOutingState createState() => _CurrentOutingState();
}

class _CurrentOutingState extends State<CurrentOuting> {
  Future<void> checkOuting(BuildContext context) async {
    Outing currentOuting = await OutingDBHelper().getMostRecentOuting();
    if (currentOuting != null) {
      if (DateTime.now().compareTo(currentOuting.endDate) >= 0 &&
          !currentOuting.hasAlarm) {
        await OutingDBHelper().delete(currentOuting.id);
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (r) => false,
        );
      } else if (!currentOuting.hasAlarm) {
        currentOuting.setAlarm();
        await OutingDBHelper().update(currentOuting);
        await LocalNotification.getState().executeNotification(currentOuting);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    LocalNotification.getState().initialize(onSelectNotification);
    checkOuting(context);
  }

  Future<void> requestCheckInType(
      BuildContext context, String phoneNumber) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 10), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (r) => false,
          );
        });
        return AlertDialog(
          title: Text(
            'Select checkin Message',
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
                      child: Text('GPS'),
                      onPressed: () async {
                        await sendMessage(true, phoneNumber);
                      },
                    ),
                    MaterialButton(
                      color: appTheme.buttonColor,
                      child: Text('No GPS'),
                      onPressed: () async {
                        await sendMessage(false, phoneNumber);
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

  Future sendMessage(bool withGps, String phoneNumber) async {
    SmsSender sender = new SmsSender();
    String cleanPhoneNumber = phoneNumber.replaceAll(new RegExp('[^0-9]'), '');
    String message = "Just Checking in ";

    if (withGps) {
      var position = await GeoLocatorHelper.getCurrentPosition();
      if (position != null) {
        message = message +
            GeoLocatorHelper.getLocationURL(
                position.longitude, position.latitude);
      } else {
        message = message + "currently unable to send location";
      }
    }
    await sender.sendSms(new SmsMessage(cleanPhoneNumber, message));
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (r) => false,
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload == LocalNotification.getState().payload) {
      Outing currentOuting = await OutingDBHelper().getMostRecentOuting();
      if (currentOuting != null) {
        if (currentOuting.hasAlarm) {
          var phoneNumber = currentOuting.contact.phoneNumber.number;
          currentOuting.cancelAlarm();
          await OutingDBHelper().update(currentOuting);

          if (currentOuting.isAuto) {
            await sendMessage(true, phoneNumber);
          } else {
            return await requestCheckInType(context, phoneNumber);
          }
        }
      }
    }
  }

  @override
  void dispose() {
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
                    args.contact.phoneNumber.number,
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
                    await LocalNotification.getState().cancelNotifications();
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
