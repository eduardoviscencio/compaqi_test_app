import 'package:flutter/material.dart';

import 'package:compaqi_test_app/presentation/theme/colors.dart';

enum SnackbarType { success, warning, error, info }

extension SnackbarTypeExtension on SnackbarType {
  Color get color {
    switch (this) {
      case SnackbarType.success:
        return successColor;
      case SnackbarType.warning:
        return warningColor;
      case SnackbarType.error:
        return errorColor;
      case SnackbarType.info:
        return infoColor;
    }
  }

  IconData get icon {
    switch (this) {
      case SnackbarType.success:
        return Icons.check_circle_outline_rounded;
      case SnackbarType.warning:
        return Icons.warning_amber_rounded;
      case SnackbarType.error:
        return Icons.error_outline_rounded;
      case SnackbarType.info:
        return Icons.info_outline_rounded;
    }
  }
}

SnackBar customSnackbar({
  required String message,
  Duration duration = const Duration(seconds: 2),
  SnackbarType? type,
}) {
  return SnackBar(
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (type != null) ...[Icon(type.icon, color: type.color), const SizedBox(width: 16)],
        Expanded(child: Text(message)),
      ],
    ),
    duration: duration,
  );
}
