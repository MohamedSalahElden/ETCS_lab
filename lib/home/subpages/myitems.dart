import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyItems extends StatefulWidget {
  final List<Map<String, dynamic>> user_items; // Declare a final field for all_items
  const MyItems({super.key, required this.user_items});
  
  @override
  _MyItemsState createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  @override
  Widget build(BuildContext context) {
    final componentProvider = Provider.of<ComponentProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: componentProvider.userComponents.isEmpty
          // If there are no items, show the image
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/no_items_here.png', height: 200), // Update the path to your image
                  SizedBox(height: 20),
                  Text(
                    'No items available!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          // If there are items, show the list
          : RefreshIndicator(
              onRefresh: () async {
                // Initialize Firebase or any required services
                await Provider.of<ComponentProvider>(context, listen: false).fetchBorrowedItems();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: componentProvider.userComponents.length,
                itemBuilder: (context, index) {
                  final item = componentProvider.userComponents[index];

                  return Dismissible(
                    key: Key(item["item_name"]),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      setState(() {
                        componentProvider.userComponents.remove(index);
                      });

                      await Provider.of<ComponentProvider>(context, listen: false).returnComponent(item['unique_code']);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item["unique_code"]} Returned to Lab')),
                      );
                    },
                    background: Container(
                      color: Color(0xffbf1e2e),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            item['item_name'][0],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          item['item_name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(item['unique_code']),
                        trailing: Icon(Icons.arrow_downward, color: Color.fromARGB(255, 3, 150, 22)),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
