// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:strava_repository/strava_repository.dart';
// import 'package:my_sport_map/utilities/utilities.dart';

// class TestConnection extends StatefulWidget {
//   const TestConnection({super.key});

//   @override
//   State<TestConnection> createState() => _TestConnectionState();
// }

// class _TestConnectionState extends State<TestConnection> {
//   String resultValue = 'No result yet';

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//             onPressed: () {
//               logger.d('Test] of Strava API');
//               context.read<StravaRepository>().listActivities().then((value) {
//                 logger.d(value);
//                 logger.d(value[0]);
//                 logger.d(value[2].map);
//                 logger.d(value[2].map?.summaryPolyline);
//                 setState(() {
//                   resultValue = value[0].toString();
//                 });
//               });
//             },
//             child: const Text('Test : get Athlete data')),
//         SizedBox(
//           height: 80,
//           child: SingleChildScrollView(
//             //child: SizedBox(
//             //height: 200,
//             child: Text(resultValue),
//             //),
//           ),
//         ),
//       ],
//     );
//   }
// }
