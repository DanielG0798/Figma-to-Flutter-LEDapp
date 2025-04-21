import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../database.dart'; // Import the database
import '../models/room.dart'; // Import the Room model

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  //late AppDatabase _database; // Remove late, initialize in initState
  List<Room> _rooms = [];
  final _roomNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDatabase(); // Call initializeDatabase in initState
  }

  Future<void> _initializeDatabase() async {
    // Initialize the database and assign it to the field.
    final database = Provider.of<AppDatabase>(context, listen: false);
    await _loadRooms(database); // Pass the database instance
  }

  Future<void> _loadRooms(AppDatabase database) async { // Receive database instance
    final rooms = await database.roomDao.getAllRooms();
    setState(() {
      _rooms = rooms;
    });
  }

  void _addRoom() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Room'),
          content: TextField(
            controller: _roomNameController,
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
              onPressed: () async {
                final name = _roomNameController.text.trim();
                if (name.isNotEmpty) {
                  final database = Provider.of<AppDatabase>(context, listen: false); // Get database
                  final newRoom = Room(
                    roomID: DateTime.now().millisecondsSinceEpoch.toString(),
                    roomName: name,
                  );
                  await database.roomDao.insertRoom(newRoom);
                  await _loadRooms(database); // Pass the database instance
                  Navigator.pop(context);
                  _roomNameController.clear();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
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
            icon: const Icon(Icons.add, size: 34,),
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
                fontSize: 18
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
            return Card(
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
                          room.roomName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: _addRoom,
          tooltip: 'Add Room',
          child: const Icon(Icons.add, size: 40),
        ),
      ),
    );
  }
}

