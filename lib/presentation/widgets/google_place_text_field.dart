import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:compaqi_test_app/infrastructure/config/config.dart' show Environment;
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';
import 'package:compaqi_test_app/presentation/ui/ui.dart' show Decorations;
import 'package:compaqi_test_app/presentation/widgets/widgets.dart'
    show customSnackbar, SnackbarType;

class GooglePlaceTextField extends StatefulWidget {
  final Completer<GoogleMapController> _cameraController;
  final Function(Prediction?)? onSelectPrediction;

  const GooglePlaceTextField({
    super.key,
    required Completer<GoogleMapController> cameraController,
    this.onSelectPrediction,
  }) : _cameraController = cameraController;

  @override
  State<GooglePlaceTextField> createState() => _GooglePlaceTextFieldState();
}

class _GooglePlaceTextFieldState extends State<GooglePlaceTextField> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      if (_textController.text.isEmpty) {
        widget.onSelectPrediction?.call(null);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _getPlaceDetailWithLatLng(Prediction prediction) async {
    final lat =
        (prediction.lat is double)
            ? prediction.lat as double
            : double.tryParse(prediction.lat?.toString() ?? '0.0') ?? 0.0;

    final lng =
        (prediction.lng is double)
            ? prediction.lng as double
            : double.tryParse(prediction.lng?.toString() ?? '0.0') ?? 0.0;

    if (lat != 0.0 && lng != 0.0) {
      widget.onSelectPrediction?.call(prediction);

      final GoogleMapController mapController = await widget._cameraController.future;
      mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          message: AppLocalizations.of(context)!.invalidLocation,
          type: SnackbarType.warning,
        ),
      );
    }
  }

  void _itemClick(Prediction prediction) {
    _textController.text = prediction.description ?? '';
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: prediction.description?.length ?? 0),
    );
  }

  Widget _itemBuilder(context, index, Prediction prediction) {
    return Container(
      padding: EdgeInsets.all(10),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(Icons.location_on, color: primaryColor, size: iconSize),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              prediction.description ?? "",
              style: TextStyle(color: primaryColor, fontSize: fontSizeText),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        children: [
          Expanded(
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _textController,
              textStyle: TextStyle(color: primaryColor, fontSize: fontSizeText),
              boxDecoration: BoxDecoration(color: backgroundColor),
              googleAPIKey: Environment.mapsApiKey,
              inputDecoration: Decorations.textFieldDecoration(
                labelText: AppLocalizations.of(context)!.searchLocationInputLabel,
                hintText: AppLocalizations.of(context)!.searchLocationInputHint,
                prefixIcon: Icons.search_rounded,
              ),
              debounceTime: 800,
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: _getPlaceDetailWithLatLng,
              itemClick: _itemClick,
              itemBuilder: _itemBuilder,
              isCrossBtnShown: true,
              containerHorizontalPadding: 10,
              placeType: PlaceType.address,
            ),
          ),
        ],
      ),
    );
  }
}
