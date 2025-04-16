import '../models/light.dart';

class Room {
  final String roomID;
  final String roomName;
  final List<Light> lights;

  Room({
    required this.roomID,
    required this.roomName,
    List<Light>? lights,
  }) : lights =
            lights ?? []; // If the passed-in lights value is not null, use it.
  //But if it's null, then use an empty list [] instead.
}
