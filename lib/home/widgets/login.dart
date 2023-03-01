//import 'dart:js';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:my_sport_map/authentication/cubit/client_cubit.dart';
import 'package:strava_repository/strava_repository.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  void _testDeauth(BuildContext context) {
    // TODO: implement testDeauth
    print("[call] testDeauth() - start");
    // TEST
    print(context.read<ClientCubit>().state);
    // Revoque the client
    context.read<ClientCubit>().setStatus(ClientStatus.needAuthentication);
    // TEST
    print(context.read<ClientCubit>().state);
    print("[call] testDeauth() - end");
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => context
                    .read<StravaRepository>()
                    .authenticate(), //testAuthentication(context),
                //onPressed: () {
                //  print('Change of page...');
                //Navigator.push(
                //    context,
                //    MaterialPageRoute(
                //        builder: (context) => AuthenticationPage()));
                //},
                child: const Text("Login With Strava"),
              ),
              ElevatedButton(
                onPressed: () => _testDeauth(context),
                child: const Text("De Authorize"),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            minLines: 1,
            maxLines: 3,
            //controller: _textEditingController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text("Access Token"),
                suffixIcon: TextButton(
                  child: const Text("Copy"),
                  onPressed: () {
                    // TODO ?
                    //FlutterClipboard.copy(_textEditingController.text).then(
                    //    ((value) => ScaffoldMessenger.of(context).showSnackBar(
                    //        const SnackBar(content: Text("Copied !")))));
                  },
                )),
          ),
          const Divider()
        ],
      );
    });
  }

  void testAuthentication(BuildContext context) {
    // TODO which one ?
    //context.read<StravaRepository>();
    RepositoryProvider.of<StravaRepository>(context).authenticate();
  }
}
