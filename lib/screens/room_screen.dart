import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../widgets/light_box_widget.dart';
import '../models/light.dart';
import '../models/room.dart';
import '../database.dart';
import 'package:provider/provider.dart'; // Import Provider

class RoomScreen extends StatefulWidget {
  final Room room; // Receive the Room object

  const RoomScreen({Key? key, required this.room}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late AppDatabase _database;
  List<Light> _lights = [];
  late final Room
      _room; // Mark as late final since it's initialized in initState

  @override
  void initState() {
    super.initState();
    _room = widget.room; // Initialize immediately
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await initializeDatabase();
    await _loadLights();
  }

  Future<void> _loadLights() async {
    final database =
        Provider.of<AppDatabase>(context, listen: false); // Get database
    final dbLights = await database.lightDao.getAllLights();
    setState(() {
      _lights = dbLights
          .where((dbLight) => dbLight.roomID == _room.id)
          .toList(); //_room.id
    });
  }

  void _addLight() {
    TextEditingController nameController = TextEditingController();
    Color selectedColor = const Color.fromARGB(255, 255, 255, 255);

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
              ColorPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) => selectedColor = color,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                String hexColor =
                    '#${selectedColor.value.toRadixString(16).substring(2)}';
                final database = Provider.of<AppDatabase>(context,
                    listen: false); // Get database
                final newLight = Light(
                  lightName: nameController.text,
                  lightColor: hexColor,
                  roomID: _room.id, // Use _room.id
                );
                await database.lightDao.insertLight(newLight);
                await _loadLights();
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _toggleLight(int index, bool newState) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    final updatedLight = _lights[index].copyWith(isOn: newState);
    await database.lightDao.updateLight(updatedLight);
    await _loadLights();
  }

// Function will help modify the light color
  void _modifyLight(int index) {
    Color pickerColor =
        Color(int.parse(_lights[index].lightColor.replaceFirst('#', '0xff')));

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
              onPressed: () async {
                setState(() {
                  String hexColor =
                      '#${pickerColor.value.toRadixString(16).substring(2)}';
                  final updateLight =
                      _lights[index].copyWith(lightColor: hexColor);
                });
                final database = Provider.of<AppDatabase>(context,
                    listen: false); // Get database

                final updatedLight = Light(
                  id: _lights[index].id,
                  roomID: _room.id, // Use _room.id
                  lightName: _lights[index].lightName,
                  lightColor: _lights[index].lightColor,
                  isOn: _lights[index].isOn,
                  mode: _lights[index].mode,
                );

                await database.lightDao.updateLight(updatedLight);
                await _loadLights();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_room.roomName),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      // Default message
      body: _lights.isEmpty
          ? Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                  children: [
                    const TextSpan(text: 'Press '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(193, 255, 255, 255),
                                width: 2),
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromARGB(255, 209, 228, 255)),
                        child: Icon(
                          Icons.bluetooth,
                          size: 20,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const TextSpan(text: ' to add a new light.'),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: _lights.length,
              itemBuilder: (context, index) {
                return LightWidget(
                  light: _lights[index],
                  onModify: () => _modifyLight(index),
                  onToggle: (newState) => _toggleLight(index, newState),
                );
              },
            ),
      // Bluetooth button
      floatingActionButton: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: _addLight,
            tooltip: 'Add Light',
            child: Icon(Icons.bluetooth, size: 40),
          )),
    );
  }
}
