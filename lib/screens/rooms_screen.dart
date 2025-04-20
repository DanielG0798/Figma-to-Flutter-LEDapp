import 'package:flutter/material.dart';
import '../models/light.dart';
import '../models/room.dart';
// Simple model for a room
/*
class Room {
  final String id;
  String name;
  List<Light> lightDevices;

  Room({required this.id, required this.name, this.lightDevices = const []});
}

*/
class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  // Store rooms in memory for now
  final List<Room> _rooms = [];

  // Show dialog to add a new room
  void _addRoom() {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Room'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Room Name',
              hintText: 'Enter room name...',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    _rooms.add(Room(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeRoom(String roomId)
  {
    setState(() {
      _rooms.removeWhere((room) => room.id == roomId);
    });
  }

  void _renameRoom(String roomId)
  {
    // To find the room by ID
    final room = _rooms.firstWhere((r) => r.id == roomId);
    // Filling with current name
    final nameController = TextEditingController(text: room.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Room'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Room Name',
              hintText: 'Enter a new name...',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if(newName.isNotEmpty && newName != room.name) {
                  setState(() {
                    room.name = newName;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${room.name} renamed to $newName')),
                  );
                }
              },
              child: const Text('Rename'),
            ),
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
        title: const Text('Rooms'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addRoom,
            tooltip: 'Add new room',
          ),
        ],
      ),
      body: _rooms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.meeting_room_outlined,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No rooms yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use the + in top right to add rooms',
                    style: TextStyle(
                      color: theme.colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final room = _rooms[index];


                  return Dismissible(

                    // To delete the room
                    key: Key(room.id), // key to identify dismissible
                    direction: DismissDirection.endToStart, // to enable the Swipe Direction
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      _removeRoom(room.id); // Removing room from the List
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${room.name} deleted')),
                      );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: theme.colorScheme.surface,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/room',
                          arguments: room,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.meeting_room,
                              size: 32,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                room.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),

                            // Icon to rename the the room
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () {
                                _renameRoom(room.id); // To open the rename dialogue
                              },
                            ),

                            Icon(
                              Icons.chevron_right,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                 );
                }
              ),
            ),
    );
  }
}

