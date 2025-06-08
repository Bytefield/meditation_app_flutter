import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/l10n/app_localizations.dart';
import 'package:meditation_app_flutter/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final currentLocale = localeProvider.locale;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // Only include supported languages (English and Spanish)
    final languages = [
      _Language(
        name: l10n.spanish,
        locale: const Locale('es'),
        flag: '🇪🇸',
        languageCode: 'es',
      ),
      _Language(
        name: l10n.english,
        locale: const Locale('en'),
        flag: '🇬🇧',
        languageCode: 'en',
      ),
      // Note: Other languages are commented out as translations are not yet available
      // _Language(
      //   name: l10n.french,
      //   locale: const Locale('fr'),
      //   flag: '🇫🇷',
      //   languageCode: 'fr',
      // ),
      // _Language(
      //   name: l10n.german,
      //   locale: const Locale('de'),
      //   flag: '🇩🇪',
      //   languageCode: 'de',
      // ),
      // _Language(
      //   name: l10n.italian,
      //   locale: const Locale('it'),
      //   flag: '🇮🇹',
      //   languageCode: 'it',
      // ),
      // _Language(
      //   name: l10n.portuguese,
      //   locale: const Locale('pt'),
      //   flag: '🇵🇹',
      //   languageCode: 'pt',
      // ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = language.locale.languageCode == currentLocale.languageCode;

          return ListTile(
            leading: Text(
              language.flag,
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(language.name),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                  )
                : null,
            onTap: () {
              localeProvider.setLocale(language.locale);
              // Close the screen after a short delay to show the selection
              Future.delayed(const Duration(milliseconds: 300), () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              });
            },
          );
        },
      ),
    );
  }
}

class _Language {
  final String name;
  final Locale locale;
  final String flag;
  final String languageCode;

  _Language({
    required this.name,
    required this.locale,
    required this.flag,
    required this.languageCode,
  });
}
