import 'package:geolocator/geolocator.dart';

class GeoLocatorHelper {
  static Future<Position> getCurrentPosition() async {
    Geolocator geolocator = new Geolocator();
    Position position;
    try {
      position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      position = null;
    }
    return position;
  }

  static String getLocationURL(dynamic satLong, dynamic satLat) {
    return "http://maps.google.com/maps?q=$satLat+N,+$satLong+E";
  }
}
