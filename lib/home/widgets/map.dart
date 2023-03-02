import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:strava_repository/strava_repository.dart';

// TODO : ATTENTION !!! Double escape the \ !!!
// fixme : look the line just over
String polylineSummary =
    r'wjigGmb_`@OqA?EXYBQGu@B[Uu@N@Xo@VSUQe@U[YHYROdB}@HBEGJBZMFGBGNG`@OPAJE@ELKDSAMI]A[_@wA@MP@`@TpAh@PZhAhAj@`ARn@\b@F?@AF]NyA?a@IgACeDKwAIc@C}A@]IWGACE?MDOEk@DmAAQOw@KgA@@@GJ@PGAGBOHCX?l@IT@t@ITDrAIrACj@Gj@?n@GxACnAKTMB@NI^Cd@?d@G`BGxAQRQBK@IG_A@KLQ`@e@POJQ^Qn@QLIBKDCf@@d@Wt@SfAe@HFLr@FhBBDDGGiA?e@Oa@Ba@RIf@a@b@GFI^@pC[X?^OZG^OSeCQYCWKa@Iu@F[Ss@UeAEo@K]?IUy@AOD[JU?KP[h@Sb@YTYBDB?FEBEH_@?GGo@O}@Cs@Ga@BYBAx@S@EEk@M}@@_@j@q@h@i@f@?s@?q@CYFGFAEE?IMC?KHMDQ@qB]O?CACCEWEq@EEoCBg@Eg@S{B@KCu@aAICqBGkB]o@Nm@M]?c@Ja@Te@NEFg@J]R_@r@GD[HiAPa@TeBd@o@`@a@F_@f@a@RONWC_BLq@CKV?h@G~@INCd@JfAFxCJ~@J`CTzA?DEDCLNv@?vAFd@ETO\Kn@Fx@CfABb@?j@Ct@GPCh@?dA[xAMz@EzAK`AAt@Cl@QpA?z@Fl@Lp@FH?BGBFCFnAEhAFNDZAz@@|@ZtD@l@Iz@RrAEl@A~ABx@Hz@DNHr@Et@I^BVDDEj@@p@RhCDNBh@RnAHXJt@JtA?h@?M?FCEBNIRIL]@[FSPg@L]Dk@PO?EK[JGAQFy@j@g@?QFY\e@@g@Fa@Wk@SIOyAs@{Ai@';

class MyMap extends StatefulWidget {
  MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController mapController;

  late Set<Polyline> myPolylines = {};

  final LatLng _center = const LatLng(43.5628075, 5.6427871);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    // Get the polylines !
    print('Requesting polylines...');
    // TODO : now test useless (?)
    if (myPolylines.isEmpty) {
      context.read<StravaRepository>().getAllPolylines().then((polylines) {
        print('Got polylines !!!');
        setState(() {
          myPolylines = polylines;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the polylines !
    // TODO : INFINITE REQUESTS !!!
    // if (myPolylines.isEmpty) {
    //   context.read<StravaRepository>().getAllPolylines().then((polylines) {
    //     print('Got polylines !!!');
    //     setState(() {
    //       myPolylines = polylines;
    //     });
    //   });
    // }

    // TEST
    //print(decodeEncodedPolyline(polylineSummary).reversed.toList());
    //return const Text("map...");
    return Expanded(
      child: GoogleMap(
        polylines: myPolylines,
        // {
        //   Polyline(
        //     polylineId: const PolylineId('a8375526289'),
        //     points: decodeEncodedPolyline(polylineSummary),
        //     width: 2,
        //   )
        // },
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
