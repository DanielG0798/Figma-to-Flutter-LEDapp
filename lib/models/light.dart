class Light {
  // final String address;
  // final String roomID;
  String lightName;
  bool isOn;
  String lightColor; // Added for color
  String mode; // Added for mode

  // Constructor with default values
  Light({
    // required this.address,
    // required this.roomID,
    required this.lightName,
    this.isOn = false,
    this.lightColor = 'white',
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
