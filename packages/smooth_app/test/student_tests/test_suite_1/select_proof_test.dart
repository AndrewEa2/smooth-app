import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/pages/prices/price_model.dart';

void main() {
  test('Shows "Select Proof" when no proof is selected', () {
    final PriceModel model = PriceModel(
      proofType: ProofType.receipt,
      currency: Currency.USD,
      multipleProducts: false,
    );

    expect(model.hasImage, isFalse);

    final String buttonText = model.hasImage
        ? 'Change proof'
        : 'Select a proof';

    expect(buttonText, 'Select a proof');
  });
}
