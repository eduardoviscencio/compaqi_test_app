import 'package:flutter/material.dart';

import 'package:compaqi_test_app/presentation/screens/screens.dart';
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/theme_data.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: surfaceColor,
      title: 'Locations App',
      theme: themeData,
      initialRoute: MapScreen.routeName,
      routes: {
        AuthScreen.routeName: ((_) => const AuthScreen()),
        MapScreen.routeName: ((_) => const MapScreen()),
        LocationsScreen.routeName: ((_) => const LocationsScreen()),
      },
    );
  }
}
