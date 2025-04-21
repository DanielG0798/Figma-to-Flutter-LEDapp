import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Import with a prefix
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/user.dart'; // Import your Floor User model
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AuthService extends ChangeNotifier {
  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? _user;
  String? _profilePicturePath;

  AuthService() {
    // Listen to auth state changes
    auth.authStateChanges().listen((firebase_auth.User? user) {
      _user = user;
      _loadProfilePicture();
      notifyListeners();
    });
  }

  firebase_auth.User? get currentUser => _user;

  bool get isLoggedIn => _user != null;

  String? get profilePicturePath => _profilePicturePath;

  Future<void> _loadProfilePicture() async {
    if (_user != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final userDir = Directory('${directory.path}/user_${_user!.uid}');
        if (await userDir.exists()) {
          final files = userDir.listSync();
          if (files.isNotEmpty) {
            _profilePicturePath = files.first.path;
            notifyListeners();
          } else {
            _profilePicturePath = null;
            notifyListeners();
          }
        } else {
          _profilePicturePath = null;
          notifyListeners();
        }
      } catch (e) {
        print('Error loading profile picture: $e');
        _profilePicturePath = null;
        notifyListeners();
      }
    } else {
      _profilePicturePath = null;
      notifyListeners();
    }
  }

  Future<String?> updateProfilePicture(String imagePath) async {
    if (_user != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final userDir = Directory('${directory.path}/user_${_user!.uid}');
        
        // Create user directory if it doesn't exist
        if (!await userDir.exists()) {
          await userDir.create(recursive: true);
        }

        // Delete all existing files in the user directory
        if (await userDir.exists()) {
          await for (final file in userDir.list()) {
            if (file is File) {
              await file.delete();
            }
          }
        }

        // Copy new image to user directory
        final fileName = 'profile_picture${path.extension(imagePath)}';
        final newPath = path.join(userDir.path, fileName);
        
        // Ensure the source file exists and is readable
        final sourceFile = File(imagePath);
        if (!await sourceFile.exists()) {
          throw Exception('Source image file does not exist');
        }

        // Copy the file
        await sourceFile.copy(newPath);
        
        // Verify the copy was successful
        final newFile = File(newPath);
        if (!await newFile.exists()) {
          throw Exception('Failed to save profile picture');
        }

        return newPath;
      } catch (e) {
        print('Error updating profile picture: $e');
        rethrow;
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> changePassword(String newPassword) async {
    try {
      if (_user != null) {
        await _user!.updatePassword(newPassword);
        notifyListeners();
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  Future<void> changeEmail(String newEmail) async {
    try {
      if (_user != null) {
        await _user!.verifyBeforeUpdateEmail(newEmail);
        notifyListeners();
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      print('Error changing email: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      if (_user != null) {
        await _user!.delete();
        _user = null;
        notifyListeners();
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
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

