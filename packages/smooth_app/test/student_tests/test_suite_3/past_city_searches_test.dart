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

  test('Stores last search by timestamp', () async {
    final LocalDatabase localDb = await LocalDatabase.getLocalDatabase();
    final DaoOsmLocation dao = DaoOsmLocation(localDb);

    final OsmLocation osmLocation = OsmLocation(
      osmId: DateTime.now().millisecondsSinceEpoch,
      osmType: LocationOSMType.node,
      longitude: 12.34,
      latitude: 56.78,
    );

    addTearDown(() async {
      await dao.delete(osmLocation);
      await localDb.database.close();
    });

    await dao.put(osmLocation);

    final List<Map<String, Object?>> rows = await localDb.database.query(
      'osm_location',
      where: 'osm_id = ? AND osm_type = ?',
      whereArgs: <Object>[osmLocation.osmId, osmLocation.osmType.offTag],
    );

    expect(rows, hasLength(1));

    final Object lastAccessValue = rows.first['last_access']!;
    final int lastAccess = lastAccessValue as int;
    expect((LocalDatabase.nowInMillis() - lastAccess).abs(), lessThan(2000));
  });
}
