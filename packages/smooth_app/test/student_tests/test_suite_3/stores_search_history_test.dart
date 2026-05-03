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

  test('InsertsCityIntoDatabase', () async {
    final LocalDatabase localDb = await LocalDatabase.getLocalDatabase();
    final DaoOsmLocation dao = DaoOsmLocation(localDb);

    final OsmLocation osmLocation = OsmLocation(
      osmId: DateTime.now().millisecondsSinceEpoch,
      osmType: LocationOSMType.node,
      longitude: 12.34,
      latitude: 56.78,
      name: 'Test Store',
      street: '123 Main St',
      city: 'Atlanta',
      postcode: '30303',
      country: 'United States',
      countryCode: 'us',
      osmKey: 'shop',
      osmValue: 'supermarket',
    );

    addTearDown(() async {
      await dao.delete(osmLocation);
      await localDb.database.close();
    });

    final int rowId = await dao.put(osmLocation);

    final List<Map<String, Object?>> rows = await localDb.database.query(
      'osm_location',
      where: 'osm_id = ? AND osm_type = ?',
      whereArgs: <Object>[osmLocation.osmId, osmLocation.osmType.offTag],
    );

    expect(rowId, greaterThan(0));
    expect(rows, hasLength(1));

    final Map<String, Object?> row = rows.first;

    expect(row['osm_id'], osmLocation.osmId);
    expect(row['osm_type'], osmLocation.osmType.offTag);
    expect(row['longitude'], osmLocation.longitude);
    expect(row['latitude'], osmLocation.latitude);
    expect(row['name'], osmLocation.name);
    expect(row['street'], osmLocation.street);
    expect(row['city'], osmLocation.city);
    expect(row['post_code'], osmLocation.postcode);
    expect(row['country'], osmLocation.country);
    expect(row['country_code'], osmLocation.countryCode);
    expect(row['osm_key'], osmLocation.osmKey);
    expect(row['osm_value'], osmLocation.osmValue);

    final Object lastAccessValue = row['last_access']!;
    final int lastAccess = lastAccessValue as int;
    final int now = LocalDatabase.nowInMillis();
    expect((now - lastAccess).abs(), lessThan(2000));
  });
}
