import 'package:floor/floor.dart';
import '../models/user_room.dart';

@dao
abstract class UserRoomDao {
  @Query('SELECT * FROM user_rooms')
  Future<List<UserRoom>> getAllUserRooms();

  @Query('SELECT * FROM user_rooms WHERE id = :id')
  Stream<UserRoom?> findUserRoomById(int id);

  @insert
  Future<int> insertUserRoom(UserRoom userRoom);

  @update
  Future<void> updateUserRoom(UserRoom userRoom);

  @delete
  Future<void> deleteUserRoom(UserRoom userRoom);

  @Query('SELECT * FROM user_rooms WHERE userID = :userId AND roomID = :roomId')
  Future<UserRoom?> findUserRoom(String userId, String roomId);
}