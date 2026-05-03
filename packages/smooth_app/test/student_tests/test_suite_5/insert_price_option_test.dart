import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/product/product_page/footer/new_product_footer.dart';
import 'package:smooth_app/themes/smooth_theme_colors.dart';
import 'package:smooth_app/themes/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('displays add price', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'currentThemeMode': 'Light',
    });

    final UserPreferences userPreferences =
        await UserPreferences.getUserPreferences();
    final ThemeProvider themeProvider = ThemeProvider(userPreferences);

    addTearDown(themeProvider.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<UserPreferences>.value(value: userPreferences),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          Provider<Product>.value(value: Product(barcode: '12345678')),
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
          home: const Scaffold(
            body: ProductFooter(
              actions: <ProductFooterActionBar>[
                ProductFooterActionBar.addPrice,
              ],
              showSettings: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Add a price'), findsOneWidget);
  });
}
