import 'package:latlong2/latlong.dart';

// TODO(nenuphar): manage this file. Where ? Remove it and use GoogleMap (?)

/// Returns a decoded `polyline` from a polyline encoded as a [String].
///
/// The encoded polyline is encoded as a sting using this algorithm :
/// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
///
/// The code to decode was inspired from Dammyololade :
/// https://gist.github.com/Dammyololade/ce4eda8544e76c8f66a2664af9a1e0f3/
List<LatLng> decodeEncodedPolyline(String encodedPolyline) {
  final polyline = <LatLng>[];
  final len = encodedPolyline.length;
  var index = 0;
  var lat = 0;
  var lng = 0;

  // For the whole encoded string, decode point by point.
  while (index < len) {
    int b;

    // Decode the latitude value
    var shift = 0;
    var result = 0;
    do {
      b = encodedPolyline.codeUnitAt(index++) - 63;
      // Remove 0x20 for concerned ones and shift the value
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    // ignore: unnecessary_parenthesis
    final dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    // Decode the longitude value
    shift = 0;
    result = 0;
    do {
      b = encodedPolyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    // ignore: unnecessary_parenthesis
    final dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    final p = LatLng(lat / 1E5, lng / 1E5);
    polyline.add(p);
  }
  return polyline;
}
