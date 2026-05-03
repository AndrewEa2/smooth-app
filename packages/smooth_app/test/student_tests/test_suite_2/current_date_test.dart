import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/pages/prices/price_model.dart';

void main() {
  test('setsDateToCurrentDate', () {
    final PriceModel model = PriceModel(
      proofType: ProofType.receipt,
      currency: Currency.USD,
      multipleProducts: false,
    );
    final DateTime today = DateTime.now();

    expect(model.date.year, today.year);
    expect(model.date.month, today.month);
    expect(model.date.day, today.day);
  });
}
