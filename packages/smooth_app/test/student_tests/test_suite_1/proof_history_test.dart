import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/pages/crop_parameters.dart';
import 'package:smooth_app/pages/prices/price_model.dart';

void main() {
  test('process sets proof when history selection returns a proof', () {
    final PriceModel model = PriceModel(
      proofType: ProofType.receipt,
      currency: Currency.USD,
      multipleProducts: false,
    );

    final CropParameters oldCropParameters = CropParameters(
      fullFile: File('old_full.jpg'),
      smallCroppedFile: File('old_small.jpg'),
      rotation: 0,
      cropRect: const Rect.fromLTWH(0, 0, 10, 10),
    );
    model.cropParameters = oldCropParameters;

    final Proof historyProof = Proof()
      ..type = ProofType.receipt
      ..currency = Currency.USD
      ..date = DateTime(2026, 4, 5)
      ..filePath = 'history_full.jpg'
      ..imageThumbPath = 'history_thumb.jpg'
      ..locationOSMId = 123
      ..locationOSMType = LocationOSMType.node;

    // The history path in the app ends by calling model.setProof(proof).
    model.setProof(historyProof);

    expect(model.proof, same(historyProof));
    expect(model.hasImage, isTrue);
    expect(model.cropParameters, isNull);
  });
}
