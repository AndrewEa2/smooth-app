import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_app/helpers/camera_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('hasACamera returns true when cameras list is not empty', () async {
      await CameraHelper.init();

    if (CameraHelper.isSupported) {
      final bool deviceHasCamera = (await availableCameras()).isNotEmpty;
      expect(CameraHelper.hasACamera, deviceHasCamera);
    } else {
      expect(CameraHelper.hasACamera, isFalse);
    }
  });
}
