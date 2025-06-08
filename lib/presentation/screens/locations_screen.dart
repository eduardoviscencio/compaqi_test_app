import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:compaqi_test_app/presentation/providers/locations/locations_state.dart';
import 'package:compaqi_test_app/presentation/providers/providers.dart';
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/widgets/widgets.dart'
    show customSnackbar, SnackbarType;

class LocationsScreen extends StatefulWidget {
  static const String routeName = 'locations_screen';

  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  String _currentUserEmail = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _currentUserEmail = context.read<AuthProvider>().state.user?.email ?? '';
      await _fetchLocations();
    });
  }

  Future<void> _fetchLocations() async {
    try {
      await context.read<LocationsProvider>().fetchLocations();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(message: AppLocalizations.of(context)!.fetchError, type: SnackbarType.error),
      );
    }
  }

  String _getUserLabel(String email) {
    return email == _currentUserEmail ? AppLocalizations.of(context)!.you : email;
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select<LocationsProvider, LocationsStatus>(
      (provider) => provider.state.status,
    );

    final locations = context.select<LocationsProvider, List>(
      (provider) => provider.state.locations,
    );

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.favoriteLocations)),
      body: Builder(
        builder: (context) {
          if (status == LocationsStatus.loading) {
            return const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: primaryColor, strokeWidth: 1.0),
              ),
            );
          }

          if (status == LocationsStatus.error) {
            return Center(child: Text(AppLocalizations.of(context)!.fetchError));
          }

          if (locations.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noLocations));
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return ListTile(
                title: Text(location.tag, overflow: TextOverflow.ellipsis, maxLines: 2),
                subtitle: Text(_getUserLabel(location.userEmail), overflow: TextOverflow.ellipsis),
                onTap: () {
                  // Handle location tap
                },
              );
            },
          );
        },
      ),
    );
  }
}
