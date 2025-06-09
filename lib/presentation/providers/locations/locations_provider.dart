import 'package:flutter/material.dart';

import 'package:compaqi_test_app/application/use_cases/use_cases.dart'
    show GetSavedLocationsUseCase, AddLocationUseCase, DeleteLocationUseCase;
import 'package:compaqi_test_app/domain/models/models.dart' show Location;
import 'package:compaqi_test_app/presentation/providers/locations/locations_state.dart';

class LocationsProvider extends ChangeNotifier {
  final GetSavedLocationsUseCase _getSavedLocationsUseCase;
  final AddLocationUseCase _addLocationUseCase;
  final DeleteLocationUseCase _deleteLocationUseCase;

  LocationsState _state = LocationsState.initial();

  LocationsProvider({
    required GetSavedLocationsUseCase getSavedLocationsUseCase,
    required AddLocationUseCase addLocationUseCase,
    required DeleteLocationUseCase deleteLocationUseCase,
  }) : _getSavedLocationsUseCase = getSavedLocationsUseCase,
       _addLocationUseCase = addLocationUseCase,
       _deleteLocationUseCase = deleteLocationUseCase;

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
