import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/authentication/cubit/client_cubit.dart';

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
              var test = client?.read(Uri.parse("${apiEndpoint}athlete"));
              test?.then(
                (value) {
                  print(value);
                  setState(() {
                    resultValue = value;
                  });
                },
              );
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
