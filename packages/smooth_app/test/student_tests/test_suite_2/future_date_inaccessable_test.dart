import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/data_models/product_preferences.dart';
import 'package:smooth_app/data_models/user_management_provider.dart';
import 'package:smooth_app/generic_lib/buttons/smooth_large_button_with_icon.dart';
import 'package:smooth_app/pages/prices/price_date_card.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/themes/color_provider.dart';
import 'package:smooth_app/themes/contrast_provider.dart';
import 'package:smooth_app/themes/theme_provider.dart';

import '../../tests_utils/mocks.dart';

void main() {
  testWidgets('disablesDateSelection', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(mockSharedPreferences());

    final UserPreferences userPreferences =
        await UserPreferences.getUserPreferences();
    late ProductPreferences productPreferences;
    final ThemeProvider themeProvider = ThemeProvider(userPreferences);
    final ColorProvider colorProvider = ColorProvider(userPreferences);
    final TextContrastProvider textContrastProvider = TextContrastProvider(
      userPreferences,
    );

    productPreferences = ProductPreferences(
      ProductPreferencesSelection(
        setImportance: userPreferences.setImportance,
        getImportance: userPreferences.getImportance,
        notify: () => productPreferences.notifyListeners(),
      ),
    );
    await productPreferences.init(PlatformAssetBundle());
    await userPreferences.init(productPreferences);

    final PriceModel model = PriceModel(
      proofType: ProofType.receipt,
      currency: Currency.USD,
      multipleProducts: false,
    );

    final Proof proof = Proof()
      ..type = ProofType.receipt
      ..currency = Currency.USD
      ..date = DateTime.now();

    model.setProof(proof);

    await tester.pumpWidget(
      MockSmoothApp(
        userPreferences,
        UserManagementProvider(),
        productPreferences,
        themeProvider,
        textContrastProvider,
        colorProvider,
        ChangeNotifierProvider<PriceModel>.value(
          value: model,
          child: Scaffold(body: ListView(children: <Widget>[PriceDateCard()])),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SmoothLargeButtonWithIcon), findsOneWidget);

    final SmoothLargeButtonWithIcon dateButton = tester
        .widget<SmoothLargeButtonWithIcon>(
          find.byType(SmoothLargeButtonWithIcon),
        );

    expect(dateButton.onPressed, isNull);
  });
}
