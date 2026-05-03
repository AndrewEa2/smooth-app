import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_app/helpers/camera_helper.dart';

void main() {
  test('hasACamera returns false when cameras list is empty', () async {
    await CameraHelper.init();

    final bool result = CameraHelper.hasACamera;

    expect(result, isFalse);
  });
}
