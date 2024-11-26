import 'package:etcs_lab_manager/home/subpages/itemActions.dart';
import 'package:etcs_lab_manager/home/subpages/itemCard.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyItems extends StatefulWidget {
  
  // ignore: non_constant_identifier_names
  final List<Map<String, dynamic>> user_items; // Declare a final field for all_items
  // ignore: non_constant_identifier_names
  const MyItems({super.key, required this.user_items});
  
  @override
  // ignore: library_private_types_in_public_api
  _MyItemsState createState() => _MyItemsState();
}

late Function(bool) myItemsGlobalSetSearchValue;

class _MyItemsState extends State<MyItems> {
  int? _expandedIndex; 
  bool _isSearch = false;
  late int itemcount;

  Color getCategoryColor(String category) {
    int hash = category.hashCode;
    int red = (hash & 0xFF0000) >> 16;
    int green = (hash & 0x00FF00) >> 8;
    int blue = hash & 0x0000FF;
    return Color.fromARGB(255, red, green, blue);
  }

void setIsSearch(bool value) {
    setState(() {
      _isSearch = value;
    });
  }

  @override
  void initState() {
    super.initState();
    myItemsGlobalSetSearchValue = setIsSearch; // Store the function reference
  }

  @override
  Widget build(BuildContext context) {
    

    final componentProvider = Provider.of<ComponentProvider>(context, listen: true);
    
    

    Map<String , dynamic> userComponents = {};
    if (_isSearch == true){userComponents = componentProvider.userComponentsToView;}
    else if (_isSearch == false){userComponents = componentProvider.userComponents;}

    itemcount = userComponents.length;




    
    return Scaffold(
      backgroundColor: Colors.white,
      body: userComponents.isEmpty
          
          // If there are no items, show the image
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/no_items_here.png', height: 200), // Update the path to your image
                  const SizedBox(height: 20),
                  const Text(
                    'No items available!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          
          // If there are items, show the list
          : RefreshIndicator(
              onRefresh: () async {await Provider.of<ComponentProvider>(context, listen: false).fetchBorrowedItems();},
              
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: itemcount,
                itemBuilder: (context, index) {
                  final item = userComponents.keys.toList()[index];
                  final isExpanded = _expandedIndex == index;
                  Map<String , dynamic> parentItem = Provider.of<ComponentProvider>(context, listen: false).getItemFromInstance(item);
                  
                  return Dismissible(
                    // Key(userComponents[item]["item_name"])
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      _expandedIndex = null;
                      dynamic itemCode = item;
                      userComponents.remove(item);
                      await Provider.of<ComponentProvider>(context, listen: false).returnComponent(itemCode);
                    },

                    background: Container(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Color(0xffbf1e2e)),
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: getCategoryColor(parentItem['section']),
                              child: Text(parentItem["section"].substring(0,2) , style: const TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                            ),
                            // leading: Icon(MdiIcons.sword),
                            title: Text(userComponents[item].containsKey("item_name") && userComponents[item]["item_name"] != null ? userComponents[item]["item_name"]!: "Default Title", style: const TextStyle(fontWeight: FontWeight.bold , color: Colors.black)),
                            
                            subtitle: Text(item , style: const TextStyle(color: Colors.black),),
                            trailing: Icon(
                              isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            onTap: () async {
                              setState(() {
                                _expandedIndex = isExpanded ? null : index;  
                                }
                              );
                            },
                          ),
                          
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                children: [
                                  ItemCard(item: parentItem,),
                                  ItemActions(
                                    item: parentItem,  
                                    bottonType: "return", 
                                    bottonState: "active", 
                                    action: () async {
                                      _expandedIndex = null;
                                      dynamic itemCode = item;
                                      userComponents.remove(item);
                                      await Provider.of<ComponentProvider>(context, listen: false).returnComponent(itemCode);
                                    },
                                  ),
                                ],
                              ) 
                            ),
                          ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
