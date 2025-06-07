import 'package:flutter/material.dart';

class LocationsScreen extends StatelessWidget {
  static const String routeName = 'locations_screen';

  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All favorite locations')),
      body: Center(child: Text('Locations Screen')),
    );
  }
}
