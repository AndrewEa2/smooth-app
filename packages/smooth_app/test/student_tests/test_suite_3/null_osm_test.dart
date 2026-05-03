import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:smooth_app/database/dao_osm_location.dart';
import 'package:smooth_app/database/local_database.dart';
import 'package:smooth_app/pages/locations/osm_location.dart';

import '../../tests_utils/path_provider_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = MockedPathProviderPlatform();

  test('put throws when Osm null', () async {
    final LocalDatabase localDb = await LocalDatabase.getLocalDatabase();
    final DaoOsmLocation dao = DaoOsmLocation(localDb);

    addTearDown(() async {
      await localDb.database.close();
    });

    final OsmLocation osmLocation = _NullTypeOsmLocation();

    expect(dao.put(osmLocation), throwsA(anything));
  });
}

class _NullTypeOsmLocation extends OsmLocation {
  _NullTypeOsmLocation()
    : super(
        osmId: 1,
        osmType: LocationOSMType.node,
        longitude: 12.34,
        latitude: 56.78,
      );

  @override
  LocationOSMType get osmType => null as dynamic;
}
