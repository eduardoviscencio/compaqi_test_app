import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';
import 'package:compaqi_test_app/presentation/widgets/widgets.dart'
    show GooglePlaceTextField, CustomDrawer;

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

    _markers.add(
      const Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(37.42796133580664, -122.085749655962),
        infoWindow: InfoWindow(title: 'Google Plex'),
      ),
    );
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
    // TODO: Implement the logic to save the selected prediction as a favorite location.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locations App')),
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
                label: const Text(
                  'Save as favorite',
                  style: TextStyle(color: lightTextColor, fontSize: fontSizeText),
                ),
              ),
    );
  }
}
