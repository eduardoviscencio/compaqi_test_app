import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:compaqi_test_app/domain/models/models.dart' show Location;
import 'package:compaqi_test_app/infrastructure/data_sources/data_sources.dart'
    show LocationDataSource;
import 'package:compaqi_test_app/domain/repositories/repositories.dart' show LocationRepository;
import 'package:compaqi_test_app/infrastructure/dtos/dtos.dart'
    show LocationsResponseDTO, LocationResponseDTO;

import 'package:compaqi_test_app/infrastructure/data_sources/data_sources.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _remoteDataSource;

  LocationRepositoryImpl({required LocationDataSource dataSource}) : _remoteDataSource = dataSource;

  @override
  Future<List<Location>> getSavedLocations() async {
    try {
      final http.Response response = await _remoteDataSource.fetchLocations();

      if (response.statusCode != 200) {
        throw Exception('Failed to load locations: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final dto = LocationsResponseDTO.fromJson(data);

      if (!dto.ok) {
        throw Exception('API responded with error');
      }

      return dto.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Location> addLocation(Location location) async {
    try {
      final http.Response response = await _remoteDataSource.saveLocation(location.toDTO());

      if (response.statusCode != 201) {
        throw Exception('Failed to save location: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final dto = LocationResponseDTO.fromJson(data);

      if (!dto.ok) {
        throw Exception('API responded with error');
      }

      return dto.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteLocation(String id) async {
    try {
      final http.Response response = await _remoteDataSource.deleteLocation(id);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete location: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
