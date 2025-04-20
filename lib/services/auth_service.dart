import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Import with a prefix
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/user.dart'; // Import your Floor User model

class AuthService extends ChangeNotifier {
  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? _user;

  AuthService() {
    // Listen to auth state changes
    auth.authStateChanges().listen((firebase_auth.User? user) { // Use the prefix here
      _user = user;
      notifyListeners();
    });
  }

  firebase_auth.User? get currentUser => _user; // Use the prefix here

  bool get isLoggedIn => _user != null;

  Future<void> signOut() async {
    await auth.signOut();
  }

  // New function: handle user sign-up
  Future<void> signUp(BuildContext context, String email, String password) async {
    try {
      final authResult =
      await firebase_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = authResult.user;
      if (firebaseUser != null) {
        // Get the Firebase User ID.
        final firebaseUserId = firebaseUser.uid;

        // Get the database instance from Provider.
        final database = Provider.of<AppDatabase>(context, listen: false);

        // Create a new User object with the Firebase User ID.
        final newUser = User( // Use your Floor User model
          userID: firebaseUserId, // Use the Firebase UID here.
          email: email,
          profileImage:
          '', // Or get the image URL from somewhere.
        );

        // Insert the user data into the Floor database.
        await database.userDao.insertUser(newUser);

        // Optionally, update the Firebase user's profile (e.g., display name).
        await firebaseUser.updateProfile(displayName: email);
        _user = firebaseUser; //update the current user.
        notifyListeners();
      }
    } catch (e) {
      // Handle errors (e.g., email already in use, weak password).
      print('Error signing up: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: $e')),
        );
      }
      rethrow; // rethrow the error so that the LoginScreen can handle it.
    }
  }
}

