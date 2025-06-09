import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:compaqi_test_app/domain/models/models.dart';
import 'package:compaqi_test_app/presentation/providers/auth/auth_provider.dart';
import 'package:compaqi_test_app/presentation/providers/auth/auth_state.dart';
import 'package:compaqi_test_app/presentation/widgets/custom_drawer.dart';

import '../../mocks/shared_mocks.mocks.dart';

class CustomAuthProvider extends AuthProvider {
  AuthState _state = AuthState.initial();

  CustomAuthProvider({required super.loginUseCase, required super.logoutUseCase});

  @override
  AuthState get state => _state;

  void setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late CustomAuthProvider authProvider;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    authProvider = CustomAuthProvider(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  Widget createTestWidget({User? user}) {
    if (user != null) {
      authProvider.setState(AuthState(user: user, status: AuthStatus.authenticated));
    } else {
      authProvider.setState(AuthState(user: null, status: AuthStatus.unauthenticated));
    }

    return ChangeNotifierProvider<AuthProvider>.value(
      value: authProvider,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('es')],
        home: Scaffold(drawer: const CustomDrawer(), body: Container()),
      ),
    );
  }

  group('CustomDrawer', () {
    testWidgets('should render user name, email, and profile picture when user is logged in', (
      WidgetTester tester,
    ) async {
      final user = User(name: 'John Doe', email: 'john.doe@example.com', picture: '');

      await tester.pumpWidget(createTestWidget(user: user));

      final ScaffoldState scaffoldState = tester.state(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pump();

      expect(find.text('John Doe'), findsOneWidget);

      expect(find.text('john.doe@example.com'), findsOneWidget);

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should render guest placeholders when no user is logged in', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final ScaffoldState scaffoldState = tester.state(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pump();

      expect(find.text('Guest'), findsOneWidget);

      expect(find.text('Not logged in'), findsOneWidget);

      final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(circleAvatar.backgroundImage, isA<AssetImage>());
      final assetImage = circleAvatar.backgroundImage as AssetImage;
      expect(assetImage.assetName, equals('assets/images/default_avatar.webp'));
    });
  });
}
