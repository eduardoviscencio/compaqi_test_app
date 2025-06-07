import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:compaqi_test_app/presentation/screens/screens.dart';
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/theme_data.dart';

import 'package:compaqi_test_app/application/use_cases/use_cases.dart' show LoginUseCase;
import 'package:compaqi_test_app/infrastructure/data_sources/data_sources.dart' show GoogleAppAuth;
import 'package:compaqi_test_app/infrastructure/repositories/repositories.dart'
    show GoogleAuthRepository;
import 'package:compaqi_test_app/presentation/providers/providers.dart' show AuthProvider;

void main() => runApp(const MyApp());

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
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: surfaceColor,
        title: 'Locations App',
        theme: themeData,
        initialRoute: AuthScreen.routeName,
        routes: {
          AuthScreen.routeName: ((_) => AuthScreen()),
          MapScreen.routeName: ((_) => const MapScreen()),
          LocationsScreen.routeName: ((_) => const LocationsScreen()),
        },
      ),
    );
  }
}
