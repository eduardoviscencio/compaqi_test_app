import 'package:flutter/material.dart';

import 'package:compaqi_test_app/application/use_cases/use_cases.dart'
    show GetSavedLocationsUseCase, AddLocationUseCase, DeleteLocationUseCase, BiometricsUseCase;
import 'package:compaqi_test_app/domain/models/models.dart' show Location;
import 'package:compaqi_test_app/presentation/providers/locations/locations_state.dart';

class LocationsProvider extends ChangeNotifier {
  final GetSavedLocationsUseCase _getSavedLocationsUseCase;
  final AddLocationUseCase _addLocationUseCase;
  final DeleteLocationUseCase _deleteLocationUseCase;
  final BiometricsUseCase _biometricsUseCase;

  LocationsState _state = LocationsState.initial();

  LocationsProvider({
    required GetSavedLocationsUseCase getSavedLocationsUseCase,
    required AddLocationUseCase addLocationUseCase,
    required DeleteLocationUseCase deleteLocationUseCase,
    required BiometricsUseCase biometricsUseCase,
  }) : _getSavedLocationsUseCase = getSavedLocationsUseCase,
       _addLocationUseCase = addLocationUseCase,
       _deleteLocationUseCase = deleteLocationUseCase,
       _biometricsUseCase = biometricsUseCase;

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

  Future<void> addLocation(Location location) async {
    try {
      _state = _state.copyWith(status: LocationsStatus.adding);
      notifyListeners();

      final Location? newLocation = await _addLocationUseCase.execute(location);

      if (newLocation == null) {
        _state = _state.copyWith(status: LocationsStatus.error);
        return;
      }

      _state = _state.copyWith(
        locations: [..._state.locations, newLocation],
        status: LocationsStatus.success,
      );
    } catch (e) {
      _state = _state.copyWith(status: LocationsStatus.error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteLocation(String id) async {
    try {
      _state = _state.copyWith(status: LocationsStatus.deleting);
      notifyListeners();

      final bool isBiometricAvailable = await _biometricsUseCase.isBiometricsAvailable();

      if (isBiometricAvailable) {
        final successLocalAuth = await _biometricsUseCase.execute();

        if (!successLocalAuth) {
          _state = _state.copyWith(status: LocationsStatus.authFailed);
          return;
        }
      }

      await _deleteLocationUseCase.execute(id);

      _state = _state.copyWith(
        locations: _state.locations.where((location) => location.id != id).toList(),
        status: LocationsStatus.success,
      );
    } catch (e) {
      _state = _state.copyWith(status: LocationsStatus.error);
    } finally {
      notifyListeners();
    }
  }
}
