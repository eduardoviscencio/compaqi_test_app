import 'package:equatable/equatable.dart';

import 'package:compaqi_test_app/domain/models/models.dart' show Location;

enum LocationsStatus { idle, loading, success, error }

class LocationsState extends Equatable {
  final List<Location> locations;
  final LocationsStatus status;

  const LocationsState({required this.locations, this.status = LocationsStatus.idle});

  factory LocationsState.initial() => LocationsState(locations: []);

  @override
  List<Object?> get props => [locations];

  LocationsState copyWith({List<Location>? locations, LocationsStatus? status}) {
    return LocationsState(locations: locations ?? this.locations, status: status ?? this.status);
  }
}
