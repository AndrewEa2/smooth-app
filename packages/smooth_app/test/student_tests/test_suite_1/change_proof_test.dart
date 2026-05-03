import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/pages/prices/price_model.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;

class FakePriceModel extends PriceModel {
  FakePriceModel()
    : super(
        proofType: ProofType.receipt,
        currency: Currency.USD,
        multipleProducts: false,
      );

  @override
  bool get hasImage => true;
}

void main() {
  test('Shows "Change Proof" when proof is already selected', () {
    final FakePriceModel model = FakePriceModel();

    final String buttonText = model.hasImage ? 'Change proof' : 'Find proof';
    final IconData leadingIcon = model.hasImage
        ? Icons.swap_horizontal_circle_rounded
        : Icons.find_in_page_rounded;
    final Widget trailingIcon = model.hasImage
        ? const icons.Edit(size: 10.0)
        : const icons.Chevron.right(size: 10.0);

    expect(buttonText, 'Change proof');
    expect(leadingIcon, Icons.swap_horizontal_circle_rounded);
    expect(trailingIcon, isA<icons.Edit>());
  });
}
