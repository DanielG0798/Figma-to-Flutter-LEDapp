import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: 'userID')  //  Use userID, not id, as the foreign key
  final String userID; // Store the Firebase User ID here.
  final String email;
  final String profileImage;

  User({
    this.id,
    required this.userID,
    required this.email,
    required this.profileImage,
  });
}