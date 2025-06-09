import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:compaqi_test_app/presentation/screens/screens.dart' show MapScreen;
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

  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _authProvider = context.read<AuthProvider>();

      _currentUserEmail = _authProvider.state.user?.email ?? '';
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

  Future<void> _onDelete(String id) async {
    try {
      await context.read<LocationsProvider>().deleteLocation(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          message: AppLocalizations.of(context)!.locationDeleted,
          type: SnackbarType.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          message: AppLocalizations.of(context)!.deleteLocationError,
          type: SnackbarType.error,
        ),
      );
    }
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
      body: RefreshIndicator(
        onRefresh: _fetchLocations,
        color: primaryColor,
        backgroundColor: backgroundColor,
        child: Builder(
          builder: (context) {
            if (status == LocationsStatus.loading && locations.isEmpty) {
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

            return ListView.separated(
              itemCount: locations.length,
              separatorBuilder: (_, __) => const Divider(height: 0.4, color: surfaceMediumColor),
              itemBuilder: (context, index) {
                final location = locations[index];

                final isCreatedByCurrentUser = location.userEmail == _currentUserEmail;

                return ListTile(
                  key: ValueKey(location.id),
                  dense: true,
                  title: Text(
                    location.tag,
                    style: TextStyle(fontSize: fontSizeText, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  subtitle: Text(
                    _getUserLabel(location.userEmail),
                    style: TextStyle(fontSize: fontSizeText),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing:
                      !isCreatedByCurrentUser
                          ? null
                          : IconButton(
                            icon: const Icon(Icons.delete, color: errorColor, size: iconSize),
                            onPressed: () => _onDelete(location.id),
                          ),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MapScreen.routeName,
                      (route) => false,
                      arguments: {'latitude': location.latitude, 'longitude': location.longitude},
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
