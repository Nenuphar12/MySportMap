import 'package:flutter/material.dart';
import 'package:my_sport_map/home/widgets/auth_management_tile.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              // Remove any padding from the ListView
              padding: EdgeInsets.zero,
              children: const [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('My Sport Map is an application allowing you'
                      ' to display all your sport activities on a single map.'
                      '\nTo get your activities, this application connects to'
                      ' Strava.'
                      '\n\nThis application is open source (source'
                      ' code : https://github.com/Nenuphar12/MySportMap)'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings (disabled)'),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                )
              ],
            ),
          ),
          // const Spacer(),
          const Divider(
            indent: 10,
            endIndent: 10,
            color: Colors.black26,
          ),
          AuthManagementTile(isLoggedIn: isLoggedIn),
        ],
      ),
    );
  }
}
