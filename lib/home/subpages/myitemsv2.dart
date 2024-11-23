import 'package:etcs_lab_manager/home/subpages/itemdetailscard.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyItemsV2 extends StatefulWidget {
  final List<Map<String, dynamic>> user_items; // Declare a final field for all_items
  const MyItemsV2({super.key, required this.user_items});
  
  @override
  _MyItemsV2State createState() => _MyItemsV2State();
}

late Function(bool) myItemsGlobalUpdateFunction;

class _MyItemsV2State extends State<MyItemsV2> {
  bool _isSearch = false;
  late int itemcount;
  
  Map<String , Color>  getItemAvailabilityColor(numberOfItems , category){
    Color icon_color = getCategoryColor(category);
    if(numberOfItems > 0){
      return {
        "textColor" : const Color.fromARGB(255, 0, 0, 0),
        "itemColor" : const Color.fromARGB(255, 255, 255, 255),
        "circleColor" : icon_color,
        "logoColor" : const Color.fromARGB(255, 42, 153, 27),
      };
    }
    else{
      
      return {
        "textColor" : const Color.fromARGB(255, 174,174,174),
        "itemColor" : const Color.fromARGB(255, 229,229,229),
        "logoColor" : const Color.fromARGB(255,  174,174,174),
        "circleColor" : const Color.fromARGB(255,  174,174,174),
      };
    }
}

  Color getCategoryColor(String category) {
    // Create a unique hash for the category
    int hash = category.hashCode;

    // Generate a color by using the hash value and mapping it to RGB
    int red = (hash & 0xFF0000) >> 16; // Extract red component
    int green = (hash & 0x00FF00) >> 8; // Extract green component
    int blue = hash & 0x0000FF; // Extract blue component

    // Return a color with full opacity
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
    myItemsGlobalUpdateFunction = setIsSearch; // Store the function reference
  }

  @override
  Widget build(BuildContext context) {
    final componentProvider = Provider.of<ComponentProvider>(context, listen: true);
    
    int? _expandedIndex; 

    Map<String , dynamic> userComponents = {};
    if (_isSearch == true){
       userComponents = componentProvider.userComponentsToView;
       print("[search] get data from userComponentsToView");
    }
    else if (_isSearch == false){
      userComponents = componentProvider.userComponents;
      print("[search] getting data from userComponents");
    }

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
                  SizedBox(height: 20),
                  const Text(
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
                itemCount: itemcount,
                itemBuilder: (context, index) {
                  print("[salah] [item] ${userComponents}");
                  final item = userComponents.keys.toList()[index];
                  print("[salah] [item] $item");
                  final isExpanded = _expandedIndex == index;
                  Map<String , dynamic> parent_item = Provider.of<ComponentProvider>(context, listen: false).getItemFromInstance(item);
                  
                  return Dismissible(
                    // Key(userComponents[item]["item_name"])
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      dynamic itemCode = item;
                      userComponents.remove(item);
                      // setState(() {});
                      await Provider.of<ComponentProvider>(context, listen: false).returnComponent(itemCode);
                
                    },

                    background: Container(
                      color: Color.fromARGB(255, 255, 255, 255),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: const Color(0xffbf1e2e)),
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
                              backgroundColor: getCategoryColor(parent_item['section']),
                              child: Text(parent_item["section"].substring(0,2) , style: const TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                            ),
                            // leading: Icon(MdiIcons.sword),
                            title: Text(userComponents[item].containsKey("item_name") && userComponents[item]["item_name"] != null ? userComponents[item]["item_name"]!: "Default Title", style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black)),
                            
                            subtitle: Text(item , style: TextStyle(color: Colors.black),),
                            trailing: Icon(
                              isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            onTap: () async {
                              setState(() {
                                // Toggle the current item's expansion and collapse others
                                _expandedIndex = isExpanded ? null : index;
                              });
                            },
                          ),
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: ItemDetailsCard(
                                item: userComponents[item],
                                itemName : userComponents[item].containsKey("item name") && userComponents[item]["item name"] != null ? userComponents[item]["item name"]!: "",
                                itemId: userComponents[item].containsKey("item Id") && userComponents[item]["item Id"] != null ? userComponents[item]["item Id"]!: "",
                                itemDetails: userComponents[item].containsKey("details") && userComponents[item]["details"] != null ? userComponents[item]["details"]!: "",
                                base64Image: "",
                                colors: {
                                          "textColor" : const Color.fromARGB(255, 0, 0, 0),
                                          "itemColor" : const Color.fromARGB(255, 255, 255, 255),
                                          "circleColor" : getCategoryColor(parent_item['section']),
                                          "logoColor" : const Color.fromARGB(255, 42, 153, 27),
                                        },
                                numberOfAvailableItems: int.parse('1'),
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
