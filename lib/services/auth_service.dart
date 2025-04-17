import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? _user;

  AuthService() {
    // Listen to auth state changes
    auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get currentUser => _user;

  bool get isLoggedIn => _user != null;

  Future<void> signOut() async {
    await auth.signOut();
  }
} 