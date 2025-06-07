import 'package:compaqi_test_app/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:compaqi_test_app/domain/models/models.dart' show User;
import 'package:compaqi_test_app/presentation/providers/providers.dart' show AuthProvider;
import 'package:compaqi_test_app/presentation/screens/screens.dart'
    show LocationsScreen, AuthScreen;
import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Future<void> _onLogout() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      customSnackbar(message: 'You have been logged out successfully.', type: SnackbarType.success),
    );

    Navigator.pop(context);

    Navigator.of(context).pushNamedAndRemoveUntil(AuthScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Builder(
              builder: (context) {
                final User? user = context.select<AuthProvider, User?>(
                  (authProvider) => authProvider.state.user,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          user?.picture != null
                              ? NetworkImage(user!.picture)
                              : const AssetImage('assets/images/default_avatar.webp')
                                  as ImageProvider,
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Text(
                        user?.name ?? 'Guest',
                        style: TextStyle(fontSize: fontSizeH1, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        user?.email ?? 'Not logged in',
                        style: TextStyle(fontSize: fontSizeText, color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, size: iconSize),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            dense: true,
            title: const Text('All favorite locations'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, LocationsScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded, size: iconSize),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            dense: true,
            title: const Text('Logout'),
            onTap: _onLogout,
          ),
        ],
      ),
    );
  }
}
