import 'package:etcs_lab_manager/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;


  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }
    });
  }

  void _toggleFormMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }
Future<void> _submit() async {
  try {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isLogin) {
      // Sign In
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      // Check if the user is signed in before navigating
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in successfully!')),
        );
        
        // Navigate to the home page after a successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }
    } else {
      // Sign Up
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed up successfully!')),
      );
    }
  } catch (e) {
    print("-----------------------------------------");
    print("--------------------exception---------------");
    print("-----------------------------------------");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }
}

  // mohamed.salah5369@gmail.com
  // password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/certLogo.png'),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffbf1e2e),
                minimumSize: const Size(double.infinity, 50), // Full width and custom height
              ),
              onPressed: _submit,
              child: Text(
                _isLogin ? 'Sign In' : 'Sign Up',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: _toggleFormMode,
              child: Text(_isLogin ? 'Don’t have an account? Sign Up' : 'Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
