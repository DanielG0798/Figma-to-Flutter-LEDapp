import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hci_project/models/room.dart';
import '../models/light.dart';
import '../widgets/light_box_widget.dart';
import 'rooms_screen.dart';
//import '../models/room.dart';

class RoomScreen extends StatefulWidget {
  
  
  const RoomScreen({super.key }); 

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}


// Underscore "_" to make private to the parent widget RoomScreen
class _RoomScreenState extends State<RoomScreen> {
  
  Color? _roomColor;  
  Room? _room;
  List<Light> _lights = []; // List to store lights added

  
  @override
  void initState() {
    super.initState();
    //_room = ModalRoute.of(context)!.settings.arguments as Room;
    //_lights = List.from(_room!.lightDevices);
    //_roomColor = _room!.colorHex != null
    //  ? Color(int.parse(_room!.colorHex!.replaceFirst('#','0xff')))
    //  : Colors.blue;
  }

  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();

    if(_room == null)
    {
      final args = ModalRoute.of(context)!.settings.arguments as Room;
      _room = args;
      _lights = List<Light>.from(_room!.lightDevices);
      _roomColor = _room!.colorHex != null
      ? Color(int.parse(_room!.colorHex!.replaceFirst('#','0xff')))
      : Colors.blue;
    }
  }
  

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

                      final newLight = Light(
                        lightName: nameController.text,
                        lightColor: hexColor,
                      );
                      _lights.add(newLight);
                      _room!.lightDevices = List.from(_lights); // sync back 
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

  void _assignDevice() async {

    //Mock devices...
    final allDevices = <Light>[
      Light(lightName: 'Desk Lamp', lightColor: '#FFFF00', isOn: false),
      Light(lightName: 'Ceiling Light', lightColor: '#FFA500', isOn: true),
      Light(lightName: 'Bed Light', lightColor: '#00FFFF', isOn: false),
      ]; // Suppose that all these mock devices are called through a method (e.g., 'getAllDevices()' )

      final availableLights = allDevices
      .where((device) => !_lights.any((light) => light.lightName == device.lightName))
      .toList();

      if (availableLights.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No available devices to assign'),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }
      /*
      List<Light> unassigned = allDevices
          .where((device) => !_room!.lightDevices.contains(device))
          .toList();
          */

      final selectedDevice =  await showDialog<Light>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Assign a device'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableLights.length,
                itemBuilder: (context,index) {
                  final device = availableLights[index];
                  return ListTile(
                    title: Text(device.lightName),
                    trailing: Icon(Icons.add),
                    onTap: () {
                      Navigator.of(context).pop(device);
                    },

                    /*
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _lights.add(device);
                          _room!.lightDevices = List.from(_lights);
                        });
                        Navigator.pop(context);
                      },
                      */
                    );
                  },
                ),
              ),
            );
          }, 
        );
        if(selectedDevice != null) {
          setState(() {
            _lights.add(selectedDevice);
            _room!.lightDevices = List.from(_lights);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${selectedDevice.lightName} assigned to ${_room!.name}.'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
  }

  void _pickRoomColor() async {

    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) {
        Color tempColor = Colors.blue;
        return AlertDialog(
          title: const Text('Select Room Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions : [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () => Navigator.of(context).pop(tempColor),
            ),
          ],
        );
      },
    );

    if(selectedColor != null) {
      setState((){
        _room!.colorHex = '#${selectedColor.value.toRadixString(16).padLeft(8,'0')}';
        
        for(var light in _lights) {
          light.lightColor = _room!.colorHex!;
        }

        _room!.lightDevices = List.from(_lights);
      });
    }
  }

  void _toggleAllLights(bool turnOn) {
    setState( () {
      for(var light in _lights) {
        light.isOn = turnOn;
      }
      _room!.lightDevices = List.from(_lights); //sync back
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          turnOn ? 'All lights turned ON' : 'All lights turned OFF',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _renameLight(int index){
    TextEditingController renameController = TextEditingController(text: _lights[index].lightName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Light'),
        content: TextField(
          controller: renameController,
          decoration: const InputDecoration(labelText: 'New name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if(renameController.text.isNotEmpty) {
                setState(() {
                  _lights[index].lightName = renameController.text;
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text ('Rename'),
          ),
        ],
      ),
    );
  }

  void _deleteLight(int index) {
      setState(() {
        _lights.removeAt(index);
        _room!.lightDevices = List.from(_lights); // sync the room's device list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Light deleted'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          ),
      );
  }


  // Function will help modify the light color
  void _modifyLight(int index) {
    Color pickerColor =
        Color(int.parse(_lights[index].lightColor.replaceFirst('#', '0xff')));
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
                  _lights[index].changeColor(hexColor);
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(_room!.name),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,

        actions: [
            PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'on') {
                _toggleAllLights(true);
              } else if (value == 'off') {
                _toggleAllLights(false);
              } else if (value == 'assign') {
                _assignDevice();
              } else if (value == 'color') {
                _pickRoomColor();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'on',
                child: Text('Turn All On'),
              ),
              const PopupMenuItem(
                value: 'off',
                child: Text('Turn All Off'),
              ),  
              const PopupMenuItem(
                value: 'assign',
                child: Text('Assign Device'),
              ),
              const PopupMenuItem(
                value: 'color',
                child: Text('Change Room Color'),
              ),
            ],
          ),
        ],
      ),
      body: _lights.isEmpty
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
              itemCount: _lights.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_lights[index].lightName),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction){
                      _deleteLight(index);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),  //..., horizontal: 12.0),
                      color: theme.colorScheme.surface,
                      child: ListTile(

                        leading: IconButton(
                          icon: Icon(
                            _lights[index].isOn ? Icons.lightbulb : Icons.lightbulb_outline,
                            color: _lights[index].isOn
                              ? Color(int.parse(_lights[index].lightColor.replaceFirst('#','0xff')))
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState( () {
                            _lights[index].toggle();
                            _room!.lightDevices = List.from(_lights);
                          });

                          //showing snackbar for lightbulb on / off
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _lights[index].isOn
                                ? '${_lights[index].lightName} turned ON'
                                : '${_lights[index].lightName} turned OFF',
                                  ),
                              duration: const Duration(milliseconds: 800),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),  
                      title: Text(_lights[index].lightName),
                      trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Rename Light',
                              onPressed: () => _renameLight(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.settings),
                              tooltip: 'Modify Light',
                              onPressed: () => _modifyLight(index),
                            ),

                            //Adding device assignment implementation
                            // Now unused since it was implemented in the top right menu with the Turn On/Off, Change Room Color
                            /*
                            IconButton(
                              icon: const Icon(Icons.link),
                              tooltip: 'Assign devices',
                              onPressed: () {
                                _assignDevice();  
                              },
                            ),
                            */

                            IconButton(
                              icon: const Icon(Icons.link_off),
                              tooltip: 'Unassign Device',
                              onPressed: () {
                                setState(() {
                                    _lights.removeAt(index);
                                    _room!.lightDevices = List.from(_lights);
                                });
                              },
                            ),
                            // End of device assign/unassign implementation
                          ],
                    ),
                    onTap: () {},
                    ),
                  ),
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
