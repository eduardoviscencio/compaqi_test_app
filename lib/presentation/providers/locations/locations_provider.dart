import 'package:flutter/material.dart';

import 'package:compaqi_test_app/application/use_cases/use_cases.dart'
    show GetSavedLocationsUseCase;
import 'package:compaqi_test_app/presentation/providers/locations/locations_state.dart';

class LocationsProvider extends ChangeNotifier {
  final GetSavedLocationsUseCase _getSavedLocationsUseCase;

  LocationsState _state = LocationsState.initial();

  LocationsProvider({required GetSavedLocationsUseCase getSavedLocationsUseCase})
    : _getSavedLocationsUseCase = getSavedLocationsUseCase;

  LocationsState get state => _state;

  Future<void> fetchLocations() async {
    try {
      _state = _state.copyWith(status: LocationsStatus.loading);
      notifyListeners();

      final locations = await _getSavedLocationsUseCase.execute();

      if (locations != null) {
        _state = _state.copyWith(locations: locations, status: LocationsStatus.success);
      } else {
        _state = _state.copyWith(status: LocationsStatus.error);
      }
    } catch (e) {
      _state = _state.copyWith(status: LocationsStatus.error);
    } finally {
      notifyListeners();
    }
  }
}
