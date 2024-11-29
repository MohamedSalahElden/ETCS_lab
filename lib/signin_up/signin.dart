import 'package:etcs_lab_manager/home/home.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  
  

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Controllers for first and last name
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _isLogin = true;



  Future<void> _signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Get the user details
      User? user = userCredential.user;

      if (user != null) {
        print("Signed in as ${user.displayName}");
        // Show success message or navigate to another page

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signed in successfully!')),
          );

          // await Provider.of<ComponentProvider>(context, listen: false).initializeComponents();
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage(user_borrowed_items: [], all_items: [],)),
          );

      }
    } catch (e) {
      print("Error during sign-in: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sign-In Failed")));
    }
  }


  @override
  void initState() {
    super.initState();
    
  }

  void _toggleFormMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<bool> _submit() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final firstName = _firstNameController.text.trim();  // First name input
      final lastName = _lastNameController.text.trim();    // Last name input

      if (_isLogin) {
        // Sign In
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signed in successfully!')),
          );

          // await Provider.of<ComponentProvider>(context, listen: false).initializeComponents();
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage(user_borrowed_items: [], all_items: [],)),
          );
        }
      } else{
          try {
            // Sign Up
            UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
            
            // Ensure the user is created and userCredential.user is not null
            if (userCredential.user != null) {
              // After signing up, update the first and last name
              await userCredential.user?.updateDisplayName('$firstName $lastName');

              // Check if the widget is still mounted before using BuildContext
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed up successfully!')),
                );
                await Provider.of<ComponentProvider>(context, listen: false).initializeComponents();
                // Navigate to the home page after successful sign-up
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage(user_borrowed_items: [], all_items: [],)),
                );
              }
            } else {
              throw Exception('User creation failed');
            }
          } catch (e) {
            // Handle errors
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
            }
            return false;
          }
        }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                  // width:50.0,  // Adjust the width
                  height: 80.0, // Adjust the height
                  child: Image.asset('assets/certLogo.png',
                    fit: BoxFit.cover,
                  ),
                ),
            const SizedBox(height: 10),
            Text("Emerging Technologies" , style: TextStyle(fontSize: 20 , color: const Color(0xffbf1e2e) , fontWeight: FontWeight.bold,),),
            Text("Cybersecurity" , style: TextStyle(fontSize: 20 , color: const Color(0xffbf1e2e) , fontWeight: FontWeight.bold,),),
            const SizedBox(height: 5),
            Text("Lab Managment System"),

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
            const SizedBox(height: 10),
            // New field for first name
            if (!_isLogin)
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
            const SizedBox(height: 10),
            // New field for last name
            if (!_isLogin)
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffbf1e2e),
                minimumSize: const Size(double.infinity, 50), // Full width and custom height
              ),
              onPressed: () async {
                _submit() ;
                await Provider.of<ComponentProvider>(context, listen: false).initializeComponents();
                },
              child: Text(
                _isLogin ? 'Sign In' : 'Sign Up',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: _toggleFormMode,
              child: Text(_isLogin ? 'Don’t have an account? Sign Up' : 'Already have an account? Sign In'),
            ),
            Text("or continue with"),
            IconButton(
              icon: Container(
                child: SizedBox(
                  width:50.0,  // Adjust the width
                  height: 50.0, // Adjust the height
                  child: Image.asset('assets/google_PNG19635.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onPressed: _signInWithGoogle,
            )
          ],
        ),
      ),
    );
  }
}
