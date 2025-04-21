import 'package:flutter/material.dart';
import '../widgets/light_box_widget.dart';
import '../models/light.dart';
import '../models/room.dart';
import '../database.dart';
import 'package:provider/provider.dart';
import '../widgets/color_and_brightness.dart';
import '../widgets/color_picker.dart';

class RoomScreen extends StatefulWidget {
  final Room room;

  const RoomScreen({super.key, required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late AppDatabase _database;
  List<Light> _lights = [];
  late final Room _room;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await initializeDatabase();
    await _loadLights();
  }

  Future<void> _loadLights() async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    final databaseLights = await database.lightDao.getAllLights();
    setState(() {
      _lights = databaseLights
          .where((databaseLight) => databaseLight.roomID == _room.id)
          .toList();
    });
  }

  void _renameLight(BuildContext context,
      {required String initialName, required void Function(String) onRenamed}) {
    final TextEditingController controller =
        TextEditingController(text: initialName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Light'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
              TextButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  onRenamed(newName);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save',style: TextStyle(fontSize: 18),),
            ),
              SizedBox(width: 90),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel',style: TextStyle(fontSize: 18),),
              ),
          ],
        );
      },
    );
  }

  void _addLight() {
    Color selectedColor = const Color(0xFFFFFFFF);
    double brightnessSelection = 75;
    TextEditingController nameController = TextEditingController();

    showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'Add New Light',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Light name'),
                  ),
                  const SizedBox(height: 16),
                  buildColorAndBrightnessPicker(
                    pickerColor: selectedColor,
                    brightness: brightnessSelection,
                    onColorChanged: (color) {
                      setStateDialog(() => selectedColor = color);
                    },
                    onBrightnessChanged: (val) {
                      setStateDialog(() => brightnessSelection = val);

                    
                    },
                  ),
                ],
              ),
            ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    final hexColor = '#${selectedColor.value.toRadixString(16).substring(2)}';
                    final database = Provider.of<AppDatabase>(context, listen: false);
                    final newLight = Light(
                      lightName: nameController.text,
                      lightColor: hexColor,
                      roomID: _room.id,
                      brightness: brightnessSelection,
                    );
                    await database.lightDao.insertLight(newLight);
                    await _loadLights();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add', style: TextStyle(fontSize: 19)),
                ),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(fontSize: 19)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}    
  void _deleteLight(int index) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    await database.lightDao.deleteLight(_lights[index]);
    await _loadLights();
  }

  void _toggleLight(int index, bool newState) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    final updatedLight = _lights[index].copyWith(isOn: newState);
    await database.lightDao.updateLight(updatedLight);
    await _loadLights();
  }

  void _modifyLight(int index) {
    Color pickerColor =
        Color(int.parse(_lights[index].lightColor.replaceFirst('#', '0xff')));
    String tempName = _lights[index].lightName;
    double brightnessSelection = _lights[index].brightness ?? 50;

    Color adjustedColor(Color color, double brightnessSelect) {
      final hsl = HSLColor.fromColor(color);
      final lightness = (brightnessSelection / 100).clamp(0.0, 1.0);
      return hsl.withLightness(lightness).toColor();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tempName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _renameLight(
                        context,
                        initialName: tempName,
                        onRenamed: (newName) {
                          setStateDialog(() {
                            tempName = newName;
                          });
                        },
                      );
                    },
                    child: const Text(
                      'Rename',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                    buildColorAndBrightnessPicker(
                      pickerColor: pickerColor,
                      brightness: brightnessSelection,
                      onColorChanged: (color) {
                        setStateDialog(() => pickerColor = color);
                      },
                      onBrightnessChanged: (val) {
                        setStateDialog(() => brightnessSelection = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final String hexColor =
                        '#${pickerColor.value.toRadixString(16).substring(2)}';

                    final updatedLight = _lights[index].copyWith(
                      lightColor: hexColor,
                      lightName: tempName,
                      brightness: brightnessSelection,
                    );

                    final database =
                        Provider.of<AppDatabase>(context, listen: false);
                    await database.lightDao.updateLight(updatedLight);

                    setState(() {
                      _lights[index] = updatedLight;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save', style: TextStyle(fontSize: 19)),
                ),
                SizedBox(width: 130),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(fontSize: 19)),
                  ),
              ],
            );
          },
        );
      },
    );
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
      body: _lights.isEmpty
          ? Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                  children: [
                    const TextSpan(text: 'Press ', style: TextStyle(fontSize: 18)),
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
                          size: 25,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const TextSpan(text: ' to add a new light.', style: TextStyle(fontSize: 18)),
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
                  onDelete: () => _deleteLight(index),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: _addLight,
            tooltip: 'Add Light',
            child: const Icon(Icons.bluetooth, size: 40),
          ),
        ),
      ),
    );
  } 
}
