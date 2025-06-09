import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import 'package:compaqi_test_app/application/use_cases/use_cases.dart';
import 'package:compaqi_test_app/domain/models/models.dart';
import 'package:compaqi_test_app/presentation/providers/auth/auth_provider.dart';
import 'package:compaqi_test_app/presentation/providers/auth/auth_state.dart';
import 'package:compaqi_test_app/presentation/providers/locations/locations_provider.dart';
import 'package:compaqi_test_app/presentation/screens/auth_screen.dart';
import 'package:compaqi_test_app/presentation/screens/map_screen.dart';

import '../../mocks/shared_mocks.mocks.dart';

class CustomAuthProvider extends AuthProvider {
  final LoginUseCase _loginUseCase;

  AuthState _state = AuthState.initial();

  CustomAuthProvider({required super.loginUseCase, required super.logoutUseCase})
    : _loginUseCase = loginUseCase;

  @override
  AuthState get state => _state;

  @override
  Future<void> login() async {
    try {
      _state = _state.copyWith(status: AuthStatus.idle);
      notifyListeners();

      final user = await _loginUseCase.execute();

      _state = _state.copyWith(user: user, status: AuthStatus.idle);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error);
    } finally {
      notifyListeners();
    }
  }
}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetSavedLocationsUseCase mockGetSavedLocationsUseCase;
  late MockAddLocationUseCase mockAddLocationUseCase;
  late MockDeleteLocationUseCase mockDeleteLocationUseCase;
  late AuthProvider authProvider;
  late LocationsProvider locationsProvider;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetSavedLocationsUseCase = MockGetSavedLocationsUseCase();
    mockAddLocationUseCase = MockAddLocationUseCase();
    mockDeleteLocationUseCase = MockDeleteLocationUseCase();

    authProvider = AuthProvider(loginUseCase: mockLoginUseCase, logoutUseCase: mockLogoutUseCase);
    locationsProvider = LocationsProvider(
      getSavedLocationsUseCase: mockGetSavedLocationsUseCase,
      addLocationUseCase: mockAddLocationUseCase,
      deleteLocationUseCase: mockDeleteLocationUseCase,
    );
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<LocationsProvider>.value(value: locationsProvider),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('es')],
        home: const AuthScreen(),
        routes: {
          MapScreen.routeName:
              (context) => const MapScreen(initialLatitude: 0.0, initialLongitude: 0.0),
        },
      ),
    );
  }

  group('AuthScreen', () {
    testWidgets('should render Login with Google button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Login with Google'), findsOneWidget);

      final loginButton = find.ancestor(
        of: find.text('Login with Google'),
        matching: find.byType(InkWell),
      );

      expect(loginButton, findsOneWidget);
    });

    testWidgets('should call AuthProvider.login when Login with Google button is pressed', (
      WidgetTester tester,
    ) async {
      var mockUser = User(
        name: 'Test User',
        email: 'test@example.com',
        picture: 'http://example.com/pic.jpg',
      );

      when(mockLoginUseCase.execute()).thenAnswer((_) async => mockUser);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final loginButton = find.ancestor(
        of: find.text('Login with Google'),
        matching: find.byType(InkWell),
      );

      await tester.tap(loginButton);
      await tester.pump();

      verify(mockLoginUseCase.execute()).called(1);
    });
  });
}
