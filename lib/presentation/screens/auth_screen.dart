import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:compaqi_test_app/presentation/providers/providers.dart' show AuthProvider;
import 'package:compaqi_test_app/presentation/theme/colors.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = 'auth_screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _authenticate() async {
    try {
      context.read<AuthProvider>().login();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You cannot login with Google. Please try again later.'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: _authenticate, child: Text('Login with Google')),
      ),
    );
  }
}
