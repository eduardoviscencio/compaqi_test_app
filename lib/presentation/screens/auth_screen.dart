import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:compaqi_test_app/presentation/providers/auth/auth_state.dart' show AuthStatus;
import 'package:compaqi_test_app/presentation/providers/providers.dart' show AuthProvider;
import 'package:compaqi_test_app/presentation/screens/screens.dart' show MapScreen;
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';
import 'package:compaqi_test_app/presentation/widgets/widgets.dart'
    show customSnackbar, SnackbarType;

class AuthScreen extends StatefulWidget {
  static const String routeName = 'auth_screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _authenticate() async {
    try {
      await context.read<AuthProvider>().login();

      if (!mounted) {
        return;
      }

      final AuthStatus status = context.read<AuthProvider>().state.status;

      if (status == AuthStatus.authenticated) {
        Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
      } else if (status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            message: AppLocalizations.of(context)!.loginError,
            type: SnackbarType.error,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            message: AppLocalizations.of(context)!.loginFailed,
            type: SnackbarType.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(message: AppLocalizations.of(context)!.loginError, type: SnackbarType.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(primaryColor.withAlpha(220), BlendMode.srcOver),
            child: Image(
              image: const AssetImage('assets/images/background.webp'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.authHeading,
                          style: TextStyle(
                            fontSize: 36,
                            color: lightTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.authSubHeading,
                          style: TextStyle(fontSize: 18, color: lightTextColor),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: surfaceColor, width: 0.4),
                      ),
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.loginGoogleLabel,
                      style: TextStyle(fontSize: fontSizeText, color: lightTextColor),
                    ),
                    icon: Image(
                      image: const AssetImage('assets/images/google_icon.webp'),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
