

import 'package:etcs_lab_manager/home/subpages/about.dart';
import 'package:etcs_lab_manager/home/subpages/itemDetailsTable.dart';
import 'package:etcs_lab_manager/home/subpages/itemEditing.dart';
import 'package:etcs_lab_manager/home/subpages/myItems.dart';
import 'package:etcs_lab_manager/home/subpages/scan.dart';
import 'package:etcs_lab_manager/home/subpages/search.dart';
import 'package:etcs_lab_manager/signin_up/auth_service.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:etcs_lab_manager/signin_up/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyHomePage extends StatefulWidget {

  final List<Map<String, dynamic>> user_borrowed_items; // Declare a field for user_borrowed_items
  final List<Map<String, dynamic>> all_items; // Declare a field for all_items
  

  const MyHomePage({
    Key? key,
    required this.user_borrowed_items,
    required this.all_items,
  }) : super(key: key);

  


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int searchClickedIndex = 0;
  bool _isSearching = false; // Flag to control the search mode
  TextEditingController _searchController = TextEditingController();
  

  int _selectedIndex = 0;
  late List<Widget> _pages; // Declare _pages as a late variable

  @override
  void initState() {
    super.initState();
    _pages = [
      MyItems(user_items: widget.user_borrowed_items,),
      AllItems(all_items: widget.all_items), // Access widget.all_items here
      const QRScanner(),
    ];
    
  }

  void _onItemTapped(int index) {
    _isSearching = false;
    setState(() {
      _selectedIndex = index;
    });
  }



  



    void _updateWithSearchedItems(String string){
      if (_selectedIndex == 0){
        if(string == ""){
          myItemsGlobalSetSearchValue(false);
        }
        else{
          myItemsGlobalSetSearchValue(true);
          print("[search] $string" );
          Provider.of<ComponentProvider>(context, listen: false).searchOnUserComponents(string);
        }
      }
      else if(_selectedIndex == 1){
        if(string == ""){
          globalUpdateFunction(false);
        }
        else{
          globalUpdateFunction(true);
          print("[search] $string" );
          Provider.of<ComponentProvider>(context, listen: false).searchOnAllComponents(string);
        }
      }
      
      
    
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffbf1e2e),
        title: _isSearching
            ? TextField(
                onChanged: (searchString) => _updateWithSearchedItems(searchString),
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              )
            : const Text(
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
        actions: [
          // Display search icon when not searching
          if (!_isSearching)
            if (_selectedIndex == 0 || _selectedIndex == 1)
            IconButton(
              
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearching = true; // Enable search mode
                });
              },
            ),
          // Display cancel icon when searching
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.white),
              onPressed: () {
                setState(() {
                  myItemsGlobalSetSearchValue(false);
                  _isSearching = false; // Disable search mode
                  _searchController.clear(); // Clear search text
                });
              },
            ),

        ],     
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
              decoration: const BoxDecoration(
                color: Color(0xffbf1e2e),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Align content vertically and center it
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.white,
                        
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      AuthService.getUserFullName(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Account'),
              selected: _selectedIndex == 0,
              onTap: () {},
            ),
            ListTile(
              title: const Text('About'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AboutPage()),
                  // MaterialPageRoute(builder: (context) =>  ModifyDataScreen()),
                  // MaterialPageRoute(builder: (context) =>  ItemDetailsTable()),
                );
              },
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child:  Divider(
              color: const Color.fromARGB(255, 207, 207, 207),
              thickness: 1,
              ),
            
            ),
            

            ListTile(
              title: const Text('Logout' , style: TextStyle(color: const Color(0xffbf1e2e)),),
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
