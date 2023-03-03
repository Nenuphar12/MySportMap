import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sport_map/authentication/cubit/client_cubit.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

// String polylineSummary =
//     r'wjigGmb_`@OqA?EXYBQGu@B[Uu@N@Xo@VSUQe@U[YHYROdB}@HBEGJBZMFGBGNG`@OPAJE@ELKDSAMI]A[_@wA@MP@`@TpAh@PZhAhAj@`ARn@\b@F?@AF]NyA?a@IgACeDKwAIc@C}A@]IWGACE?MDOEk@DmAAQOw@KgA@@@GJ@PGAGBOHCX?l@IT@t@ITDrAIrACj@Gj@?n@GxACnAKTMB@NI^Cd@?d@G`BGxAQRQBK@IG_A@KLQ`@e@POJQ^Qn@QLIBKDCf@@d@Wt@SfAe@HFLr@FhBBDDGGiA?e@Oa@Ba@RIf@a@b@GFI^@pC[X?^OZG^OSeCQYCWKa@Iu@F[Ss@UeAEo@K]?IUy@AOD[JU?KP[h@Sb@YTYBDB?FEBEH_@?GGo@O}@Cs@Ga@BYBAx@S@EEk@M}@@_@j@q@h@i@f@?s@?q@CYFGFAEE?IMC?KHMDQ@qB]O?CACCEWEq@EEoCBg@Eg@S{B@KCu@aAICqBGkB]o@Nm@M]?c@Ja@Te@NEFg@J]R_@r@GD[HiAPa@TeBd@o@`@a@F_@f@a@RONWC_BLq@CKV?h@G~@INCd@JfAFxCJ~@J`CTzA?DEDCLNv@?vAFd@ETO\Kn@Fx@CfABb@?j@Ct@GPCh@?dA[xAMz@EzAK`AAt@Cl@QpA?z@Fl@Lp@FH?BGBFCFnAEhAFNDZAz@@|@ZtD@l@Iz@RrAEl@A~ABx@Hz@DNHr@Et@I^BVDDEj@@p@RhCDNBh@RnAHXJt@JtA?h@?M?FCEBNIRIL]@[FSPg@L]Dk@PO?EK[JGAQFy@j@g@?QFY\e@@g@Fa@Wk@SIOyAs@{Ai@';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

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

    if (context.read<ClientCubit>().state == ClientState.ready) {
      // Get the polylines !
      logger.v('Requesting polylines...');
      context.read<StravaRepository>().getAllPolylines().then((polylines) {
        logger.v('Got polylines !!!');
        setState(() {
          myPolylines = polylines;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GoogleMap(
        polylines: myPolylines,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
