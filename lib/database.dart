import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'models/room.dart';
import 'models/light.dart';
import 'models/user.dart';
import 'models/user_room.dart';
import 'daos/room_dao.dart';
import 'daos/light_dao.dart';
import 'daos/user_dao.dart';
import 'daos/user_room_dao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Room, Light, User, UserRoom])
abstract class AppDatabase extends FloorDatabase {
  RoomDao get roomDao;
  LightDao get lightDao;
  UserDao get userDao;
  UserRoomDao get userRoomDao;
}

Future<AppDatabase> initializeDatabase() async {
  return $FloorAppDatabase.databaseBuilder('app_database.db').build();
}