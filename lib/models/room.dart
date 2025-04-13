import '../models/light.dart';

class Room {
  final String id;
  final String name;
  final List<Light> lights;

  Room({
    required this.id,
    required this.name,
    List<Light>? lights,
  }) : lights = lights ?? [];
}
