import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/locations/osm_location.dart';
import 'package:smooth_app/pages/prices/price_add_helper.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/themes/smooth_theme_colors.dart';
import 'package:smooth_app/themes/theme_provider.dart';
import 'package:smooth_app/widgets/smooth_view_padding.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('when currency does not match city', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'currentThemeMode': 'Light',
    });

    final UserPreferences userPreferences =
        await UserPreferences.getUserPreferences();
    final ThemeProvider themeProvider = ThemeProvider(userPreferences);

    addTearDown(themeProvider.dispose);

    late BuildContext context;

    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>.value(
        value: themeProvider,
        child: SmoothViewPadding(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              extensions: <ThemeExtension<dynamic>>[
                SmoothColorsThemeExtension.defaultValues(true),
              ],
            ),
            home: Builder(
              builder: (BuildContext builderContext) {
                context = builderContext;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final PriceAddHelper helper = PriceAddHelper(context);
    final PriceModel model = PriceModel(
      proofType: ProofType.receipt,
      currency: Currency.USD,
      multipleProducts: false,
    );
    const OsmLocation location = OsmLocation(
      osmId: 1,
      osmType: LocationOSMType.node,
      longitude: 12.34,
      latitude: 56.78,
      city: 'Paris',
      countryCode: 'fr',
    );

    final OpenFoodFactsCountry? country = OpenFoodFactsCountry.fromOffTag(
      location.countryCode,
    );

    expect(country, isNotNull);
    expect(country!.currency, Currency.EUR);

    final Future<void> updateFuture = helper.updateCurrency(location, model);
    await tester.pumpAndSettle();

    expect(model.location, same(location));
    expect(model.currency, Currency.USD);
    expect(find.byType(BottomSheet), findsOneWidget);

    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    await updateFuture;

    expect(model.currency, Currency.USD);
  });
}
