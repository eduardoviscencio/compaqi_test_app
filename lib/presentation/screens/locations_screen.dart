import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LocationsScreen extends StatelessWidget {
  static const String routeName = 'locations_screen';

  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.favoriteLocations)),
      body: Center(child: Text('Locations Screen')),
    );
  }
}
