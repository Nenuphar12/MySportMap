import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  void _testDeauth() {
    // TODO: implement testDeauth
    print("[call] testDeauth()");
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
                //onPressed: testAuthentication,
                onPressed: () {
                  print('Change of page...');
                  //Navigator.push(
                  //    context,
                  //    MaterialPageRoute(
                  //        builder: (context) => AuthenticationPage()));
                },
                child: const Text("Login With Strava"),
              ),
              ElevatedButton(
                onPressed: _testDeauth,
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
}
