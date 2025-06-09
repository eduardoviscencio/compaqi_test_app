import 'dart:async';

import 'package:compaqi_test_app/domain/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:compaqi_test_app/presentation/providers/locations/locations_state.dart';
import 'package:compaqi_test_app/presentation/providers/providers.dart' show LocationsProvider;
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';
import 'package:compaqi_test_app/presentation/widgets/widgets.dart'
    show GooglePlaceTextField, CustomDrawer, SaveLocationBottomSheet, customSnackbar, SnackbarType;

class MapScreen extends StatefulWidget {
  static const String routeName = 'map_screen';

  final double initialLatitude;
  final double initialLongitude;

  const MapScreen({super.key, required this.initialLatitude, required this.initialLongitude});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Set<Marker> _markers = <Marker>{};

  Prediction? _selectedPrediction;

  late CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(0.0, 0.0), zoom: 15.0);

  late LocationsProvider _locationsProvider;

  @override
  void initState() {
    super.initState();

    _locationsProvider = context.read<LocationsProvider>();
    _locationsProvider.addListener(_onLocationsUpdated);

    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.initialLatitude, widget.initialLongitude),
      zoom: widget.initialLatitude == 0.0 && widget.initialLongitude == 0.0 ? 0.0 : 15.0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchLocations();
      _generateMarkers();
    });
  }

  @override
  void dispose() {
    _locationsProvider.removeListener(_onLocationsUpdated);
    super.dispose();
  }

  Future<void> _fetchLocations() async {
    try {
      await context.read<LocationsProvider>().fetchLocations();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(message: 'Failed to fetch locations', type: SnackbarType.error),
      );
    }
  }

  void _onLocationsUpdated() {
    final state = context.read<LocationsProvider>().state;

    if (state.status == LocationsStatus.loading) {
      return;
    }

    final newMarkers = state.locations.map((location) {
      return Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(title: location.tag, snippet: location.userEmail),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });

    setState(() {
      _markers
        ..clear()
        ..addAll(newMarkers);
    });
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    setState(() {});
  }

  void _onSelectPrediction(Prediction? prediction) {
    if (prediction?.placeId == _selectedPrediction?.placeId) {
      return;
    }

    if (prediction == null) {
      setState(() {
        _selectedPrediction = null;
        _markers.removeWhere((marker) => marker.markerId.value == 'temporal');
      });

      return;
    }

    final Marker temporalMarker = Marker(
      markerId: MarkerId('temporal'),
      position: LatLng(double.parse(prediction.lat!), double.parse(prediction.lng!)),
      infoWindow: InfoWindow(title: AppLocalizations.of(context)!.selectedLocation),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      _selectedPrediction = prediction;
      _markers.removeWhere((marker) => marker.markerId.value == 'temporal');
      _markers.add(temporalMarker);
    });
  }

  Future<void> _onSaved(String? value) async {
    try {
      if (value != null && value.isNotEmpty) {
        final Location newLocation = Location(
          id: DateTime.now().toIso8601String(),
          tag: value,
          latitude: double.parse(_selectedPrediction!.lat!),
          longitude: double.parse(_selectedPrediction!.lng!),
          placeId: _selectedPrediction!.placeId!,
        );

        await context.read<LocationsProvider>().addLocation(newLocation);

        setState(() {
          _selectedPrediction = null;
          _markers.removeWhere((marker) => marker.markerId.value == 'temporal');
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            message: AppLocalizations.of(context)!.locationSaved,
            type: SnackbarType.success,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          message: AppLocalizations.of(context)!.locationSaveError,
          type: SnackbarType.error,
        ),
      );
    }
  }

  void _onPressFAB() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SaveLocationBottomSheet(onSaved: _onSaved);
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
                initialCameraPosition: _initialCameraPosition,

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
