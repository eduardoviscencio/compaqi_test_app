import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:compaqi_test_app/presentation/screens/screens.dart';
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/theme_data.dart';

import 'package:compaqi_test_app/application/use_cases/use_cases.dart';
import 'package:compaqi_test_app/di/injection.dart';
import 'package:compaqi_test_app/infrastructure/data_sources/data_sources.dart';
import 'package:compaqi_test_app/infrastructure/repositories/repositories.dart';
import 'package:compaqi_test_app/presentation/providers/providers.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => AuthProvider(
                loginUseCase: LoginUseCase(
                  authRepository: GoogleAuthRepository(dataSource: GoogleAppAuth()),
                ),
                logoutUseCase: LogoutUseCase(
                  authRepository: GoogleAuthRepository(dataSource: GoogleAppAuth()),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => LocationsProvider(
                getSavedLocationsUseCase: DependencyInjector.getSavedLocationsUseCase(),
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: surfaceColor,
        title: 'Locations App',
        theme: themeData,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('es')],
        initialRoute: LoadingCredentialsScreen.routeName,
        routes: {
          LoadingCredentialsScreen.routeName: ((_) => const LoadingCredentialsScreen()),
          AuthScreen.routeName: ((_) => AuthScreen()),
          MapScreen.routeName: ((_) => const MapScreen()),
          LocationsScreen.routeName: ((_) => const LocationsScreen()),
        },
      ),
    );
  }
}
