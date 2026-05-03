import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/onboarding/currency_selector.dart';
import 'package:smooth_app/pages/prices/currency_extension.dart';
import 'package:smooth_app/themes/smooth_theme_colors.dart';
import 'package:smooth_app/themes/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('updates user currency', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'currentThemeMode': 'Light',
    });

    final UserPreferences userPreferences =
        await UserPreferences.getUserPreferences();
    final ThemeProvider themeProvider = ThemeProvider(userPreferences);
    await userPreferences.setUserCurrencyCode('USD');

    addTearDown(themeProvider.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: <ChangeNotifierProvider<dynamic>>[
          ChangeNotifierProvider<UserPreferences>.value(value: userPreferences),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[
              SmoothColorsThemeExtension.defaultValues(true),
            ],
          ),
          home: Scaffold(
            body: Center(
              child: CurrencySelector(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(userPreferences.userCurrencyCode, 'USD');
    expect(find.text(Currency.USD.getFullName()), findsOneWidget);

    await tester.tap(find.byType(CurrencySelector));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'EUR');
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOneWidget);

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(userPreferences.userCurrencyCode, 'EUR');
    expect(find.text(Currency.EUR.getFullName()), findsOneWidget);
  });
}
