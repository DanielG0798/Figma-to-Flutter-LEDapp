import 'package:floor/floor.dart';

@Entity(tableName: 'lights')
class Light {
  @PrimaryKey(autoGenerate: true)
  final int? id; // Changed from roomID to id
  final String lightName;
  bool isOn;
  String lightColor;
  final int? roomID; // Added roomID as a separate field
  String mode;

  Light({
    this.id, // Keep the id
    required this.lightName,
    this.isOn = false,
    this.lightColor = 'white',
    this.roomID,
    this.mode = 'normal',
  });

  // Method to toggle light state
  void toggle() {
    isOn = !isOn;
  }

  // Method to change light color
  void changeColor(String newColor) {
    lightColor = newColor;
  }

  // Method to change light mode
  void changeMode(String newMode) {
    mode = newMode;
  }
}