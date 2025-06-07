import 'package:flutter/material.dart';

import 'package:compaqi_test_app/presentation/screens/screens.dart';
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Text('Map Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, size: iconSize),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            dense: true,
            title: const Text('Our favorite locations'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, LocationsScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded, size: iconSize),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            dense: true,
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
