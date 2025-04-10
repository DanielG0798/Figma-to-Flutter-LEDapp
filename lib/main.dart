import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/rooms_screen.dart';
import 'screens/room_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Light Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/rooms': (context) => const RoomsScreen(),
        '/room': (context) => const RoomScreen(),
      },
    );
  }
}
