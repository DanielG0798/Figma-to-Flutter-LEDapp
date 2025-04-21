import 'package:floor/floor.dart';
import '../models/light.dart';

@dao
abstract class LightDao {
  @Query('SELECT * FROM lights')
  Future<List<Light>> getAllLights();

  @Query('SELECT * FROM lights WHERE id = :id')
  Stream<Light?> findLightById(int id);

  @insert
  Future<int> insertLight(Light light);

  @update
  Future<void> updateLight(Light light);

  @delete
  Future<void> deleteLight(Light light);
}
