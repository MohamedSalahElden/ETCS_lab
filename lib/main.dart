import 'package:etcs_lab_manager/firebase_options.dart';
import 'package:etcs_lab_manager/home/home.dart';
import 'package:etcs_lab_manager/signin_up/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Declare the page as a widget, initially set to AuthPage
  dynamic page = const AuthPage();

  @override
  void initState() {
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    
    // Listen for auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // If the user is signed in, change the page to MyHomePage
        setState(() {
          page = const MyHomePage();
        });
      } else {
        // If the user is signed out, stay on the AuthPage
        setState(() {
          page = const AuthPage();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: page,  // Dynamically update the home widget
    );
  }
}
