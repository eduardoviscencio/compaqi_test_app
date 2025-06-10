import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';
import 'package:compaqi_test_app/presentation/ui/ui.dart' show Decorations;

class SaveLocationBottomSheet extends StatefulWidget {
  final Function(String?) onSaved;

  const SaveLocationBottomSheet({super.key, required this.onSaved});

  @override
  State<SaveLocationBottomSheet> createState() => _SaveLocationBottomSheetState();
}

class _SaveLocationBottomSheetState extends State<SaveLocationBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _value = '';

  void _onSaved() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState?.save();

    if (_value != null && _value!.isNotEmpty) {
      widget.onSaved(_value);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.saveLocationHeading,
              style: TextStyle(
                fontSize: fontSizeText,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: TextFormField(
                autocorrect: false,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: fontSizeText),
                cursorColor: primaryColor,
                decoration: Decorations.textFieldDecoration(
                  hintText: AppLocalizations.of(context)!.saveLocationInputHint,
                  labelText: AppLocalizations.of(context)!.saveLocationInputLabel,
                ),
                minLines: 1,
                maxLines: 1,
                validator: (value) => value == null || value.isEmpty ? '' : null,
                onSaved: (value) => _value = value,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: _onSaved,
              label: Text(
                AppLocalizations.of(context)!.saveLocationLabel,
                style: TextStyle(fontSize: fontSizeText, color: primaryColor),
              ),
              icon: const Icon(Icons.check_rounded, color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
