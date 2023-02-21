import 'package:flutter/material.dart';

class ApiGroups extends StatelessWidget {
  const ApiGroups({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: IgnorePointer(
          ignoring: !isLoggedIn,
          child: AnimatedOpacity(
            opacity: isLoggedIn ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                ListTile(
                  title: Text("Athletes"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  title: Text("Clubs"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  title: Text("Gears"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  title: Text("Routes"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  title: Text("Running Races"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  title: Text("Segment Efforts"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  title: Text("Segments"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  title: Text("Streams"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  title: Text("Uploads"),
                  trailing: Icon(Icons.chevron_right),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
