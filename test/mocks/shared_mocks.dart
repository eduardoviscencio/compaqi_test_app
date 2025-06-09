import 'package:mockito/annotations.dart';

import 'package:compaqi_test_app/application/use_cases/use_cases.dart';

@GenerateMocks([
  LoginUseCase,
  LogoutUseCase,
  GetSavedLocationsUseCase,
  AddLocationUseCase,
  DeleteLocationUseCase,
  BiometricsUseCase,
])
void main() {}
