// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  RoomDao? _roomDaoInstance;

  LightDao? _lightDaoInstance;

  UserDao? _userDaoInstance;

  UserRoomDao? _userRoomDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `rooms` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `roomID` TEXT NOT NULL, `roomName` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `lights` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `lightName` TEXT NOT NULL, `isOn` INTEGER NOT NULL, `lightColor` TEXT NOT NULL, `roomID` INTEGER, `mode` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userID` TEXT NOT NULL, `email` TEXT NOT NULL, `profileImage` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user_rooms` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userID` TEXT NOT NULL, `roomID` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  RoomDao get roomDao {
    return _roomDaoInstance ??= _$RoomDao(database, changeListener);
  }

  @override
  LightDao get lightDao {
    return _lightDaoInstance ??= _$LightDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  UserRoomDao get userRoomDao {
    return _userRoomDaoInstance ??= _$UserRoomDao(database, changeListener);
  }
}

class _$RoomDao extends RoomDao {
  _$RoomDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _roomInsertionAdapter = InsertionAdapter(
            database,
            'rooms',
            (Room item) => <String, Object?>{
                  'id': item.id,
                  'roomID': item.roomID,
                  'roomName': item.roomName
                },
            changeListener),
        _roomUpdateAdapter = UpdateAdapter(
            database,
            'rooms',
            ['id'],
            (Room item) => <String, Object?>{
                  'id': item.id,
                  'roomID': item.roomID,
                  'roomName': item.roomName
                },
            changeListener),
        _roomDeletionAdapter = DeletionAdapter(
            database,
            'rooms',
            ['id'],
            (Room item) => <String, Object?>{
                  'id': item.id,
                  'roomID': item.roomID,
                  'roomName': item.roomName
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Room> _roomInsertionAdapter;

  final UpdateAdapter<Room> _roomUpdateAdapter;

  final DeletionAdapter<Room> _roomDeletionAdapter;

  @override
  Future<List<Room>> getAllRooms() async {
    return _queryAdapter.queryList('SELECT * FROM rooms',
        mapper: (Map<String, Object?> row) => Room(
            id: row['id'] as int?,
            roomID: row['roomID'] as String,
            roomName: row['roomName'] as String));
  }

  @override
  Stream<Room?> findRoomById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM rooms WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Room(
            id: row['id'] as int?,
            roomID: row['roomID'] as String,
            roomName: row['roomName'] as String),
        arguments: [id],
        queryableName: 'rooms',
        isView: false);
  }

  @override
  Future<int> insertRoom(Room room) {
    return _roomInsertionAdapter.insertAndReturnId(
        room, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRoom(Room room) async {
    await _roomUpdateAdapter.update(room, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRoom(Room room) async {
    await _roomDeletionAdapter.delete(room);
  }
}

class _$LightDao extends LightDao {
  _$LightDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _lightInsertionAdapter = InsertionAdapter(
            database,
            'lights',
            (Light item) => <String, Object?>{
                  'id': item.id,
                  'lightName': item.lightName,
                  'isOn': item.isOn ? 1 : 0,
                  'lightColor': item.lightColor,
                  'roomID': item.roomID,
                  'mode': item.mode
                },
            changeListener),
        _lightUpdateAdapter = UpdateAdapter(
            database,
            'lights',
            ['id'],
            (Light item) => <String, Object?>{
                  'id': item.id,
                  'lightName': item.lightName,
                  'isOn': item.isOn ? 1 : 0,
                  'lightColor': item.lightColor,
                  'roomID': item.roomID,
                  'mode': item.mode
                },
            changeListener),
        _lightDeletionAdapter = DeletionAdapter(
            database,
            'lights',
            ['id'],
            (Light item) => <String, Object?>{
                  'id': item.id,
                  'lightName': item.lightName,
                  'isOn': item.isOn ? 1 : 0,
                  'lightColor': item.lightColor,
                  'roomID': item.roomID,
                  'mode': item.mode
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Light> _lightInsertionAdapter;

  final UpdateAdapter<Light> _lightUpdateAdapter;

  final DeletionAdapter<Light> _lightDeletionAdapter;

  @override
  Future<List<Light>> getAllLights() async {
    return _queryAdapter.queryList('SELECT * FROM lights',
        mapper: (Map<String, Object?> row) => Light(
            id: row['id'] as int?,
            lightName: row['lightName'] as String,
            isOn: (row['isOn'] as int) != 0,
            lightColor: row['lightColor'] as String,
            roomID: row['roomID'] as int?,
            mode: row['mode'] as String));
  }

  @override
  Stream<Light?> findLightById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM lights WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Light(
            id: row['id'] as int?,
            lightName: row['lightName'] as String,
            isOn: (row['isOn'] as int) != 0,
            lightColor: row['lightColor'] as String,
            roomID: row['roomID'] as int?,
            mode: row['mode'] as String),
        arguments: [id],
        queryableName: 'lights',
        isView: false);
  }

  @override
  Future<int> insertLight(Light light) {
    return _lightInsertionAdapter.insertAndReturnId(
        light, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateLight(Light light) async {
    await _lightUpdateAdapter.update(light, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteLight(Light light) async {
    await _lightDeletionAdapter.delete(light);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'userID': item.userID,
                  'email': item.email,
                  'profileImage': item.profileImage
                },
            changeListener),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'userID': item.userID,
                  'email': item.email,
                  'profileImage': item.profileImage
                },
            changeListener),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'userID': item.userID,
                  'email': item.email,
                  'profileImage': item.profileImage
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            userID: row['userID'] as String,
            email: row['email'] as String,
            profileImage: row['profileImage'] as String));
  }

  @override
  Stream<User?> findUserById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            userID: row['userID'] as String,
            email: row['email'] as String,
            profileImage: row['profileImage'] as String),
        arguments: [id],
        queryableName: 'users',
        isView: false);
  }

  @override
  Future<int> insertUser(User user) {
    return _userInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$UserRoomDao extends UserRoomDao {
  _$UserRoomDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userRoomInsertionAdapter = InsertionAdapter(
            database,
            'user_rooms',
            (UserRoom item) => <String, Object?>{
                  'id': item.id,
                  'userID': item.userID,
                  'roomID': item.roomID
                },
            changeListener),
        _userRoomUpdateAdapter = UpdateAdapter(
            database,
            'user_rooms',
            ['id'],
            (UserRoom item) => <String, Object?>{
                  'id': item.id,
                  'userID': item.userID,
                  'roomID': item.roomID
                },
            changeListener),
        _userRoomDeletionAdapter = DeletionAdapter(
            database,
            'user_rooms',
            ['id'],
            (UserRoom item) => <String, Object?>{
                  'id': item.id,
                  'userID': item.userID,
                  'roomID': item.roomID
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserRoom> _userRoomInsertionAdapter;

  final UpdateAdapter<UserRoom> _userRoomUpdateAdapter;

  final DeletionAdapter<UserRoom> _userRoomDeletionAdapter;

  @override
  Future<List<UserRoom>> getAllUserRooms() async {
    return _queryAdapter.queryList('SELECT * FROM user_rooms',
        mapper: (Map<String, Object?> row) => UserRoom(
            id: row['id'] as int?,
            userID: row['userID'] as String,
            roomID: row['roomID'] as String));
  }

  @override
  Stream<UserRoom?> findUserRoomById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM user_rooms WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserRoom(
            id: row['id'] as int?,
            userID: row['userID'] as String,
            roomID: row['roomID'] as String),
        arguments: [id],
        queryableName: 'user_rooms',
        isView: false);
  }

  @override
  Future<UserRoom?> findUserRoom(
    String userId,
    String roomId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM user_rooms WHERE userID = ?1 AND roomID = ?2',
        mapper: (Map<String, Object?> row) => UserRoom(
            id: row['id'] as int?,
            userID: row['userID'] as String,
            roomID: row['roomID'] as String),
        arguments: [userId, roomId]);
  }

  @override
  Future<int> insertUserRoom(UserRoom userRoom) {
    return _userRoomInsertionAdapter.insertAndReturnId(
        userRoom, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUserRoom(UserRoom userRoom) async {
    await _userRoomUpdateAdapter.update(userRoom, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUserRoom(UserRoom userRoom) async {
    await _userRoomDeletionAdapter.delete(userRoom);
  }
}
