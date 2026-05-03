import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/pages/crop_parameters.dart';
import 'package:smooth_app/pages/prices/price_model.dart';

void main() {
  test(
    'process sets cropParameters when camera is selected and image is returned',
    () async {
      final PriceModel model = PriceModel(
        proofType: ProofType.receipt,
        currency: Currency.USD,
        multipleProducts: false,
      );
      final CropParameters cropParameters = CropParameters(
        fullFile: File('full.jpg'),
        smallCroppedFile: File('small.jpg'),
        rotation: 0,
        cropRect: const Rect.fromLTWH(0, 0, 10, 10),
      );

      model.cropParameters = cropParameters;

      expect(model.cropParameters, cropParameters);
      expect(model.proof, isNull);
    },
  );
}
