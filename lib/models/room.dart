import '../models/light.dart';

class Room {
  final String id;
  String name;
  List<Light> lightDevices;
  String? colorHex;

  Room({
    required this.id,
    required this.name,
    //this.lightDevices = const [],
    this.colorHex,

    List<Light>? lightsDevices,
  })
   : lightDevices =
            lightsDevices ?? []; // If the passed-in lightsDevices value is not null, use it.
  //But if it's null, then use an empty list [] instead.
}
