import 'package:google_maps_flutter/google_maps_flutter.dart';

// TODO : manage this file. Where ?

// Algorithm source :
// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
// Code "inspiration" :
// https://gist.github.com/Dammyololade/ce4eda8544e76c8f66a2664af9a1e0f3/
List<LatLng> decodeEncodedPolyline(String encodedPolyline) {
  List<LatLng> polyline = [];
  int len = encodedPolyline.length, index = 0;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encodedPolyline.codeUnitAt(index++) - 63;
      // Remove 0x20 for concerned ones and shift the value
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encodedPolyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    polyline.add(p);
  }
  return polyline;
}
