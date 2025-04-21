import 'package:floor/floor.dart';

@Entity(tableName: 'rooms')
class Room {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String roomID;
  final String roomName;

  Room({
    this.id,
    required this.roomID,
    required this.roomName,
  });
}