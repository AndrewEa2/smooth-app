import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/database/local_database.dart';
import 'package:smooth_app/generic_lib/widgets/picture_not_found.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/price_meta_product.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/pages/prices/price_product_list_tile.dart';
import 'package:smooth_app/themes/smooth_theme_colors.dart';
import 'package:smooth_app/themes/theme_provider.dart';

import '../../tests_utils/local_database_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('itemNotFound', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'currentThemeMode': 'Light',
    });

    final UserPreferences userPreferences =
        await UserPreferences.getUserPreferences();
    await userPreferences.setTheme('Light');

    final ThemeProvider themeProvider = ThemeProvider(userPreferences);
    final LocalDatabase localDatabase = MockLocalDatabase();
    final PriceModel priceModel = PriceModel(
      proofType: ProofType.receipt,
      currency: Currency.USD,
      multipleProducts: false,
    );

    addTearDown(themeProvider.dispose);

    final PriceMetaProduct product = PriceMetaProduct.unknown(
      '12345678',
      localDatabase,
      priceModel,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<UserPreferences>.value(value: userPreferences),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<LocalDatabase>.value(value: localDatabase),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            extensions: <ThemeExtension<dynamic>>[
              SmoothColorsThemeExtension.defaultValues(true),
            ],
          ),
          home: Scaffold(body: PriceProductListTile(product: product)),
        ),
      ),
    );

    await tester.pump();

    await tester.pumpWidget(
      MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<UserPreferences>.value(value: userPreferences),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<LocalDatabase>.value(value: localDatabase),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            extensions: <ThemeExtension<dynamic>>[
              SmoothColorsThemeExtension.defaultValues(true),
            ],
          ),
          home: Scaffold(body: PriceProductListTile(product: product)),
        ),
      ),
    );

    expect(find.text('Product not found'), findsOneWidget);
    expect(find.byType(PictureNotFound), findsOneWidget);
  });
}
