// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:etcs_lab_manager/signin_up/signin.dart';  // Import AuthPage or LoginPage

class AuthService {
  // Static method to log out the user
  static Future<void> userlogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  static String getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      // Return the email if the user is signed in
      return user.email ?? "No email available";
    } else {
      // Return a message if no user is signed in
      return "No user signed in";
    }
  }

  



}





