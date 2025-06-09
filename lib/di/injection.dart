import 'package:compaqi_test_app/domain/repositories/location_repository.dart';
import 'package:compaqi_test_app/infrastructure/data_sources/data_sources.dart';
import 'package:compaqi_test_app/application/use_cases/use_cases.dart';
import 'package:compaqi_test_app/infrastructure/repositories/repositories.dart';

class DependencyInjector {
  static final GoogleAppAuth _googleAppAuth = GoogleAppAuth();
  static final GoogleAuthRepository _googleAuthRepository = GoogleAuthRepository(
    dataSource: _googleAppAuth,
  );
  static final BiometricsRepositoryImpl _biometricsRepository = BiometricsRepositoryImpl(
    localAuth: LocalAuthDataSource(),
  );

  static final LocationRemoteDataSource _locationRemoteDataSource = LocationRemoteDataSource();
  static final LocationRepository _locationRepository = LocationRepositoryImpl(
    dataSource: _locationRemoteDataSource,
  );

  static LoginUseCase loginUseCase() => LoginUseCase(authRepository: _googleAuthRepository);

  static BiometricsUseCase biometricsUseCase() =>
      BiometricsUseCase(biometricsRepository: _biometricsRepository);

  static LogoutUseCase logoutUseCase() => LogoutUseCase(authRepository: _googleAuthRepository);

  static GetSavedLocationsUseCase getSavedLocationsUseCase() =>
      GetSavedLocationsUseCase(locationRepository: _locationRepository);

  static AddLocationUseCase addLocationUseCase() =>
      AddLocationUseCase(locationRepository: _locationRepository);

  static DeleteLocationUseCase deleteLocationUseCase() =>
      DeleteLocationUseCase(locationRepository: _locationRepository);
}
