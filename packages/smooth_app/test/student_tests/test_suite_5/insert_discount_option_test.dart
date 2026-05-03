import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/price_amount_card.dart';
import 'package:smooth_app/pages/prices/price_meta_product.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/themes/smooth_theme_colors.dart';
import 'package:smooth_app/themes/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('display discounted option', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'currentThemeMode': 'Light',
    });

    final UserPreferences userPreferences = await UserPreferences.getUserPreferences();
    final ThemeProvider themeProvider = ThemeProvider(userPreferences);

    addTearDown(themeProvider.dispose);

    final PriceModel model = PriceModel(
      proofType: ProofType.receipt,
      currency: Currency.USD,
      multipleProducts: false,
      initialProduct: PriceMetaProduct.category(
        categoryName: 'Apple Pie',
        originNames: <String>['United States'],
        language: OpenFoodFactsLanguage.ENGLISH,
      ),
    );
    model.elementAt(0).promo = true;

    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>.value(
        value: themeProvider,
        child: ChangeNotifierProvider<PriceModel>.value(
          value: model,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
              extensions: <ThemeExtension<dynamic>>[
                SmoothColorsThemeExtension.defaultValues(true),
              ],
            ),
            home: Scaffold(
              body: PriceAmountCard(index: 0, key: UniqueKey()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Is discounted?'), findsOneWidget);
    expect(find.text('Discounted price'), findsOneWidget);
    expect(find.text('Original price'), findsOneWidget);
  });
}
