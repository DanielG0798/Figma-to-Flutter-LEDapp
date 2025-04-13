class Light {
  final String name;
  bool isOn;
  String color; // Added for color
  String mode; // Added for mode

  // Constructor with default values
  Light({
    required this.name,
    this.isOn = false,
    this.color = 'white',
    this.mode = 'normal',
  });

  // Method to toggle light state
  void toggle() {
    isOn = !isOn;
  }

  // Method to change light color
  void changeColor(String newColor) {
    color = newColor;
  }

  // Method to change light mode
  void changeMode(String newMode) {
    mode = newMode;
  }
}
