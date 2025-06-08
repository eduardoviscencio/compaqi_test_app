import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:compaqi_test_app/presentation/providers/providers.dart' show AuthProvider;
import 'package:compaqi_test_app/presentation/screens/screens.dart' show MapScreen, AuthScreen;
import 'package:compaqi_test_app/presentation/theme/colors.dart';

class LoadingCredentialsScreen extends StatefulWidget {
  static const String routeName = 'loading_credentials_screen';

  const LoadingCredentialsScreen({super.key});

  @override
  State<LoadingCredentialsScreen> createState() => _LoadingCredentialsScreenState();
}

class _LoadingCredentialsScreenState extends State<LoadingCredentialsScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // if (kReleaseMode) {
    //   print('Checking session in release mode...');
    // }

    // if (kDebugMode) {
    //   print('Checking session in debug mode...');
    // }

    final authProvider = context.read<AuthProvider>();
    final isLoggedIn = await authProvider.isLoggedIn();

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacementNamed(isLoggedIn ? MapScreen.routeName : AuthScreen.routeName);

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(color: backgroundColor, strokeWidth: 1.0),
        ),
      ),
    );
  }
}
