import 'package:floor/floor.dart';

@Entity(tableName: 'lights')
class Light {
  @PrimaryKey(autoGenerate: true)
  final int? id; // Changed from roomID to id
  final String lightName;
  final bool isOn;
  final String lightColor;
  final int? roomID; // Added roomID as a separate field
  final double brightness;

  Light({
    this.id, // Keep the id
    required this.lightName,
    this.isOn = false,
    this.lightColor = 'white',
    this.roomID,
    this.brightness = 50,
  });

  Light copyWith({
    int? id,
    String? lightName,
    bool? isOn,
    String? lightColor,
    int? roomID,
    double? brightness,
  }) {
    return Light(
      id: id ?? this.id,
      lightName: lightName ?? this.lightName,
      isOn: isOn ?? this.isOn,
      lightColor: lightColor ?? this.lightColor,
      roomID: roomID ?? this.roomID,
      brightness: brightness ?? this.brightness,
    );
  }
}
