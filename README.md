# Figma-to-Flutter-LEDapp

A Flutter-based mobile application to control LED lights. The UI is inspired by a custom design prototype made in Figma, aiming for accessability and intuitive user experience.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Contributions](#contributions)
- [Bugs](#bugs)
- [Figma](#figma)
- [License](#license)
  
## Features

- Organize LED lights within rooms
- Choose colors and brightness levels
- Smooth navigation and UI interactions
  
## Installation

### Prerequisites
  - Visual Studio Code (recommended)
      with Flutter
      and Dart Extention
  - Android Studio

1. Clone the repo:
   ```bash
    git clone https://github.com/DanielG0798/Figma-to-Flutter-LEDapp.git
    cd Figma-to-Flutter-LEDapp
   ```
2. Get dependencies
   ```bash
   flutter pub get
   ```
3. Run Flutter project (Make sure a device or emulator is running before you execute flutter run)
   ```bash
   flutter run
   ```
## Contributions
### Project Structure Guidelines
  Please follow the structure and naming conventions below when contributing:

Class Names

- Use PascalCase (e.g., LightMode, LoginScreen, LightWidget)
  
File Names
- Use snake_case for all file names (e.g., login_screen.dart, light_widget.dart)
  
Methods & Variables

- Use camelCase (e.g., toggleLight, onLoginPressed, roomName)
- Use clear and descriptive names
  
### models/
- Contains all data models used across the app.
- Each class should represent a core entity (e.g., User, Light, Room) and reflect the structure of the database or backend API.

### screens/
- Contains full UI screens of the app (e.g., login page, user profile page, rooms overview).
- Each screen is usually a StatefulWidget or StatelessWidget composed of multiple widgets.
  
### services/
Handles business logic and external communications, including:
- Database operations, Bluetooth connectivity, LED light controller communication etc.
- Each service should be modular and focused on a specific concern (e.g., DatabaseService, BluetoothService)
- Services should not contain UI logic
### widgets/
Reusable UI components that are smaller than full screens.
   ```dart
  class LightWidget extends StatelessWidget {
      final Light light;
      final VoidCallback onModify;

    const LightWidget({
      super.key,
      required this.light,
      required this.onModify,
  });
  ```
  Examples include custom buttons, tiles, forms, or styled containers.
  
### Adding new feature
1. Create a new branch from main:
    ```bash
    git checkout -b feature/your-feature-name
    ```
2. Commit with clear message:
   ```bash
    git commit -m "your feature description"
    ```
3. Push and open a Pull Request:
   ```bash
    git push --set-upstream origin feature/your-feature-name
   ```
## Bugs

See the [bug report template](https://github.com/DanielG0798/Figma-to-Flutter-LEDapp/blob/main/bug_report.md) for instructions on reporting a bug.

## Figma

- Link to [Figma project](https://www.figma.com/design/BOtLVqHceiSiQvZMMl1RdM/LED-Lamp-Remake?m=auto&t=4zbWZKLIKTsUth06-6)
- Link to [Figma prototype version](https://www.figma.com/proto/BOtLVqHceiSiQvZMMl1RdM?node-id=0-1&t=4zbWZKLIKTsUth06-6)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

