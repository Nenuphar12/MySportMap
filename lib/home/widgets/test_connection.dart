import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/authentication/cubit/client_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strava_repository/strava_repository.dart';

// TODO clean this
const String apiEndpoint = "https://www.strava.com/api/v3/";

class TestConnection extends StatefulWidget {
  const TestConnection({super.key});

  @override
  State<TestConnection> createState() => _TestConnectionState();
}

class _TestConnectionState extends State<TestConnection> {
  String resultValue = 'No result yet';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              print('[Test] of Strava API');
              var client = context.read<ClientCubit>().state.client;
              // Get the athlete informations
              //var test = client?.read(Uri.parse("${apiEndpoint}athlete"));
              // Get some activities of the athlete
              //var test = client?.read(
              //    Uri.parse("${apiEndpoint}athlete/activities?per_page=5"));
              var test = context
                  .read<StravaRepository>()
                  .listActivities()
                  .then((value) {
                print(value);
                print(value[0]);
                setState(() {
                  resultValue = value[0].toString();
                });
              });
              /*
              var test = client
                  ?.read(Uri.parse("${apiEndpoint}activities/8375526289"));
              test?.then(
                (value) {
                  print(value);
                  var activity = Activity.fromJson(jsonDecode(value));
                  print(activity);
                  print(activity.map);
                  print(activity.map?.summaryPolyline);
                  print('polyline :');
                  print(activity.map?.polyline);
                  print('id :');
                  print(activity.map?.id);

                  final prefs = SharedPreferences.getInstance();
                  prefs.then((value) {
                    value.setString(
                        "activity_test", jsonEncode(activity.toJson()));
                  });

                  setState(() {
                    //resultValue = value;
                    resultValue = activity.map?.summaryPolyline ??
                        "No summaryPolyline in the result...";
                  });
                },
              );
                */
            },
            child: const Text('Test : get Athlete data')),
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            //child: SizedBox(
            //height: 200,
            child: Text(resultValue),
            //),
          ),
        ),
      ],
    );
  }
}
