import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// TODO : ATTENTION !!! Double escape the \ !!!
// fixme : look the line just over
String polylineSummary =
    r'wjigGmb_`@OqA?EXYBQGu@B[Uu@N@Xo@VSUQe@U[YHYROdB}@HBEGJBZMFGBGNG`@OPAJE@ELKDSAMI]A[_@wA@MP@`@TpAh@PZhAhAj@`ARn@\b@F?@AF]NyA?a@IgACeDKwAIc@C}A@]IWGACE?MDOEk@DmAAQOw@KgA@@@GJ@PGAGBOHCX?l@IT@t@ITDrAIrACj@Gj@?n@GxACnAKTMB@NI^Cd@?d@G`BGxAQRQBK@IG_A@KLQ`@e@POJQ^Qn@QLIBKDCf@@d@Wt@SfAe@HFLr@FhBBDDGGiA?e@Oa@Ba@RIf@a@b@GFI^@pC[X?^OZG^OSeCQYCWKa@Iu@F[Ss@UeAEo@K]?IUy@AOD[JU?KP[h@Sb@YTYBDB?FEBEH_@?GGo@O}@Cs@Ga@BYBAx@S@EEk@M}@@_@j@q@h@i@f@?s@?q@CYFGFAEE?IMC?KHMDQ@qB]O?CACCEWEq@EEoCBg@Eg@S{B@KCu@aAICqBGkB]o@Nm@M]?c@Ja@Te@NEFg@J]R_@r@GD[HiAPa@TeBd@o@`@a@F_@f@a@RONWC_BLq@CKV?h@G~@INCd@JfAFxCJ~@J`CTzA?DEDCLNv@?vAFd@ETO\Kn@Fx@CfABb@?j@Ct@GPCh@?dA[xAMz@EzAK`AAt@Cl@QpA?z@Fl@Lp@FH?BGBFCFnAEhAFNDZAz@@|@ZtD@l@Iz@RrAEl@A~ABx@Hz@DNHr@Et@I^BVDDEj@@p@RhCDNBh@RnAHXJt@JtA?h@?M?FCEBNIRIL]@[FSPg@L]Dk@PO?EK[JGAQFy@j@g@?QFY\e@@g@Fa@Wk@SIOyAs@{Ai@';

class MyMap extends StatelessWidget {
  MyMap({super.key});

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(43.5628075, 5.6427871);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // TEST
    //print(decodeEncodedPolyline(polylineSummary).reversed.toList());
    //return const Text("map...");
    return Expanded(
      child: GoogleMap(
        polylines: {
          Polyline(
            polylineId: const PolylineId('a8375526289'),
            points: decodeEncodedPolyline(polylineSummary),
            width: 2,
          )
        },
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}

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
