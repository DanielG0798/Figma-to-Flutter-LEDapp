import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/light.dart';
import '../widgets/light_box_widget.dart';
import 'rooms_screen.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

// Underscore "_" to make private to the parent widget RoomScreen
class _RoomScreenState extends State<RoomScreen> {
  List<Light> lights = []; // List to store lights added

  void _addLight() {
    // Color picker is here and default color can be changed here as well
    TextEditingController nameController = TextEditingController();
    Color selectedColor = const Color.fromARGB(255, 255, 255, 255);
    // New light and color happens here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Light'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Light name'),
              ),
              const SizedBox(height: 16),
              // Widgeet for colorpicking
              ColorPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) => selectedColor = color,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                // New light gets created and added to the list
                setState(() {
                  String hexColor = // hex color to hex string
                      '#${selectedColor.value.toRadixString(16).substring(2)}';
                  lights.add(Light(
                      lightName: nameController.text, lightColor: hexColor));
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Function will help modify the light color
  void _modifyLight(int index) {
    Color pickerColor =
        Color(int.parse(lights[index].lightColor.replaceFirst('#', '0xff')));
    // Modification of existing light happens here
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) => pickerColor = color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  String hexColor =
                      '#${pickerColor.value.toRadixString(16).substring(2)}';
                  lights[index].changeColor(hexColor);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = ModalRoute.of(context)!.settings.arguments as Room;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(room.name),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: lights.isEmpty
          ? Center(
              child: Text(
                'No lights in this room yet.',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: lights.length,
              itemBuilder: (context, index) {
                return LightWidget(
                  light: lights[index],
                  onModify: () => _modifyLight(index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLight,
        tooltip: 'Add Light',
        child: const Icon(Icons.add),
      ),
    );
  }
}
