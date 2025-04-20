import 'package:floor/floor.dart';

@Entity(tableName: 'user_rooms')
class UserRoom {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String userID;
  final String roomID;

  UserRoom({
    this.id,
    required this.userID,
    required this.roomID,
  });
}