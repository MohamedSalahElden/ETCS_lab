
import 'package:etcs_lab_manager/signin_up/auth_service.dart';
import 'package:etcs_lab_manager/signin_up/signin.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages; // Declare _pages as a late variable

  @override
  void initState() {
    super.initState();
    _pages = [
      Text("my items"),
      Text("all items"),
      Text("scanner"),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


 



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xffbf1e2e),
        title: const Text(
          'ETCS Lab',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu , color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),


      body: _pages[_selectedIndex], // Use the dynamically initialized _pages
      
      
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffbf1e2e),
              ),
              child: Center(
                  child: Text(
                    AuthService.getUserEmail(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
            ),
            ListTile(
              title: const Text('Logout'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                AuthService.userlogout(context);
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
              },
            ),
            
          ],
        ),
      ),
      
      
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task_rounded),
            label: 'My Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.aspect_ratio_rounded),
            label: 'Scan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xffbf1e2e),
        onTap: _onItemTapped,
      ),
    );
  }
}
