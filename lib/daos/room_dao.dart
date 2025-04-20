import 'package:floor/floor.dart';
import '../models/room.dart';

@dao
abstract class RoomDao {
  @Query('SELECT * FROM rooms')
  Future<List<Room>> getAllRooms();

  @Query('SELECT * FROM rooms WHERE id = :id')
  Stream<Room?> findRoomById(int id);

  @insert
  Future<int> insertRoom(Room room);

  @update
  Future<void> updateRoom(Room room);

  @delete
  Future<void> deleteRoom(Room room);
}