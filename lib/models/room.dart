import '../models/light.dart';

class Room {
  final String roomID;
  final String roomName;
  final List<Light> lights;

  Room({
    required this.roomID,
    required this.roomName,
    List<Light>? lights,
  }) : lights = lights ?? [];
}
