import 'package:battle_buddies/models/outing.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static LocalNotification _instance;
  FlutterLocalNotificationsPlugin notificationPlugin;
  bool hasNotifications;
  String payload = "Execute";

  LocalNotification() {
    this.notificationPlugin = new FlutterLocalNotificationsPlugin();
    this.hasNotifications = false;
  }

  static LocalNotification getState() {
    if (_instance == null) {
      _instance = new LocalNotification();
    }

    return _instance;
  }

  initialize(Future<dynamic> Function(String) onSelectNotification) {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    this.notificationPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  executeNotification(Outing outing) async {
    await this.cancelNotifications();
    String title = "Check In Time!";
    String body = outing.isAuto
        ? "Tap To Send Location to: "
        : "Tap to choose Message to send to: ";
    body = body + '${outing.contact.fullName}';
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('outing', 'outing', 'Check In');
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    this.hasNotifications = true;
    await this.notificationPlugin.schedule(
          0,
          title,
          body,
          DateTime.now().add(outing.checkInInterval),
          platformChannelSpecifics,
          payload: this.payload,
          androidAllowWhileIdle: true,
        );
  }

  cancelNotifications() async {
    if (this.hasNotifications) {
      await this.notificationPlugin.cancelAll();
      this.hasNotifications = false;
    }
  }
}
