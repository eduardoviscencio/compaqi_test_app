import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:compaqi_test_app/presentation/providers/providers.dart' show LocationsProvider;
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';
import 'package:compaqi_test_app/presentation/widgets/widgets.dart'
    show GooglePlaceTextField, CustomDrawer, SaveLocationBottomSheet, customSnackbar, SnackbarType;

class MapScreen extends StatefulWidget {
  static const String routeName = 'map_screen';

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Set<Marker> _markers = <Marker>{};

  Prediction? _selectedPrediction;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchLocations();
      _generateMarkers();
    });
  }

  Future<void> _fetchLocations() async {
    try {
      await context.read<LocationsProvider>().fetchLocations();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(message: 'Could not fetch locations', type: SnackbarType.error),
      );
    }
  }

  void _generateMarkers() {
    final locations = context.read<LocationsProvider>().state.locations;

    if (locations.isEmpty) {
      return;
    }

    for (final location in locations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: location.tag, snippet: location.userEmail),
        ),
      );
    }

    setState(() {});
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void _onSelectPrediction(Prediction? prediction) {
    if (prediction?.placeId == _selectedPrediction?.placeId) {
      return;
    }

    setState(() {
      _selectedPrediction = prediction;
    });
  }

  void _onPressFAB() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SaveLocationBottomSheet(
          onSaved: (String? value) {
            if (value != null && value.isNotEmpty) {
              print(value);
              // addField(value);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locations App')),
      resizeToAvoidBottomInset: false,
      drawer: CustomDrawer(),
      drawerEnableOpenDragGesture: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GooglePlaceTextField(
                cameraController: _controller,
                onSelectPrediction: _onSelectPrediction,
              ),
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                markers: _markers,
                initialCameraPosition: _kGooglePlex,

                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          _selectedPrediction == null
              ? null
              : FloatingActionButton.extended(
                isExtended: true,
                backgroundColor: primaryColor,
                onPressed: _onPressFAB,
                icon: const Icon(Icons.favorite, size: iconSize, color: lightTextColor),
                label: Text(
                  AppLocalizations.of(context)!.saveFavoriteLabel,
                  style: TextStyle(color: lightTextColor, fontSize: fontSizeText),
                ),
              ),
    );
  }
}
