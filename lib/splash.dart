import 'package:etcs_lab_manager/home/home.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:etcs_lab_manager/signin_up/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    // Initialize Firebase or any required services
    await Provider.of<ComponentProvider>(context, listen: false).initializeComponents();
    

    auth.authStateChanges().listen(
      (User? user) async {
        if (user != null) {
          // User is signed in, navigate to the home screen
          await Provider.of<ComponentProvider>(context, listen: false).fetchBorrowedItems();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage(user_borrowed_items: [], all_items: [],)),
          );
        }
        else{
          await Provider.of<ComponentProvider>(context, listen: false).fetchBorrowedItems();
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Background color
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Logo
              Image.asset(
                'assets/certLogo.png', // Replace with your app logo path
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              // Loading Indicator
              const CircularProgressIndicator(
                color: Color(0xffbf1e2e),
              ),
              const SizedBox(height: 10),
              // Loading Text
            ],
          ),
        ),
      ),
    );
  }
}
