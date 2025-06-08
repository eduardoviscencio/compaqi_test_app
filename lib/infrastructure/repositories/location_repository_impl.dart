import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:compaqi_test_app/domain/models/models.dart' show Location;
import 'package:compaqi_test_app/infrastructure/data_sources/data_sources.dart'
    show LocationDataSource;
import 'package:compaqi_test_app/domain/repositories/repositories.dart' show LocationRepository;
import 'package:compaqi_test_app/infrastructure/dtos/dtos.dart' show LocationsDTO;

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
      final dto = LocationsDTO.fromJson(data);

      if (!dto.ok) {
        throw Exception('API response not OK');
      }

      return dto.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<void> saveLocation(Location location) async {
  //   try {
  //     await _remoteDataSource.postLocation(location);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> deleteLocation(String id) async {
  //   try {
  //     await _remoteDataSource.removeLocation(id);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // @override
  // Future<bool> isLocationSaved(String id) async {
  //   try {
  //     return await _remoteDataSource.exists(id);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
