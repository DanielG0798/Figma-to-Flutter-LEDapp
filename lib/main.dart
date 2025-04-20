import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'database.dart'; // Import your database.dart
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/room_screen.dart';
import 'services/auth_service.dart';
import 'models/room.dart'; // Import Room model

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize the database here.  This ensures it's ready before any other widget needs it.
  final database = await initializeDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        // Provide the database instance to the whole app.
        Provider<AppDatabase>(create: (_) => database),
      ],
      child: const MyApp(),
    ),
  );
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
      home: Consumer<AuthService>(
        builder: (context, authService, _) {
          return authService.isLoggedIn
              ? const MainNavigationScreen()
              : const LoginScreen();
        },
      ),
      routes: {
        '/home': (context) => const MainNavigationScreen(),
        '/room': (context) => RoomScreen(room: ModalRoute.of(context)!.settings.arguments as Room), // Pass the room here
      },
    );
  }
}

