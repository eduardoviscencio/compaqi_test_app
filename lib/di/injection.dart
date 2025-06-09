import 'package:compaqi_test_app/domain/repositories/location_repository.dart';
import 'package:compaqi_test_app/infrastructure/data_sources/location_remote_data_source.dart';
import 'package:compaqi_test_app/infrastructure/repositories/location_repository_impl.dart';
import 'package:compaqi_test_app/application/use_cases/use_cases.dart';

class DependencyInjector {
  static final LocationRemoteDataSource _locationRemoteDataSource = LocationRemoteDataSource();
  static final LocationRepository _locationRepository = LocationRepositoryImpl(
    dataSource: _locationRemoteDataSource,
  );

  static GetSavedLocationsUseCase getSavedLocationsUseCase() =>
      GetSavedLocationsUseCase(locationRepository: _locationRepository);

  static AddLocationUseCase addLocationUseCase() =>
      AddLocationUseCase(locationRepository: _locationRepository);
}
