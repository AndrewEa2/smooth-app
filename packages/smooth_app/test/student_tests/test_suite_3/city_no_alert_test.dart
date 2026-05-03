import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/pages/locations/osm_location.dart';
import 'package:smooth_app/pages/prices/price_add_helper.dart';
import 'package:smooth_app/pages/prices/price_model.dart';

void main() {
  testWidgets('when currency matches city', (WidgetTester tester) async {
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

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
      city: 'Atlanta',
      countryCode: 'us',
    );

    final OpenFoodFactsCountry? country = OpenFoodFactsCountry.fromOffTag(
      location.countryCode,
    );

    expect(country, isNotNull);
    expect(country!.currency, Currency.USD);

    await helper.updateCurrency(location, model);
    await tester.pump();

    expect(model.location, same(location));
    expect(model.currency, Currency.USD);
    expect(find.byType(BottomSheet), findsNothing);
  });
}
