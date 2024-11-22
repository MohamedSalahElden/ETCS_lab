

import 'package:etcs_lab_manager/home/subpages/itemdetailscard.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class AllItems extends StatefulWidget {
  final List<Map<String, dynamic>> all_items; // Declare a final field for all_items

  const AllItems({Key? key, required this.all_items}) : super(key: key);

  @override
  _AllItemsState createState() => _AllItemsState();
}







class _AllItemsState extends State<AllItems> {
  int? _expandedIndex; // Track the currently expanded item index
  

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











  @override
  Widget build(BuildContext context) {
    
    final componentProvider = Provider.of<ComponentProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: RefreshIndicator(
      onRefresh: () async {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        // Initialize Firebase or any required services
        await Provider.of<ComponentProvider>(context, listen: false).initializeComponents();
      },

      child: ListView.builder(

        
        padding: const EdgeInsets.all(8.0),
        itemCount: componentProvider.allComponents.length,
        itemBuilder: (context, index) {
          final isExpanded = _expandedIndex == index;
          final item = componentProvider.allComponents[index];
          String qty = item["inLabComponents"] != null ? item["inLabComponents"].toInt().toString() : "0";
          Map<String , Color> colors = getItemAvailabilityColor(int.parse(qty) , item["technology"]);
          // String status = item["Status"] != null ? item["Status"].toString() : "None";
          
          
          return Card(
            

            color: colors['itemColor'],
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colors['circleColor'],
                    // child: const Icon(Icons.info, color: Colors.white),
                    child: Text(item["technology"].substring(0, 2) , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                  ),
                  // leading: Icon(MdiIcons.sword),
                  title: Text(item.containsKey("item name") && item["item name"] != null ? item["item name"]!: "Default Title", style: TextStyle(fontWeight: FontWeight.bold , color: colors["textColor"])),
                  
                  subtitle: Text("$qty items in lab" , style: TextStyle(color: colors["textColor"]),),
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
                      itemName : item.containsKey("item name") && item["item name"] != null ? item["item name"]!: "",
                      itemDetails: item.containsKey("details") && item["details"] != null ? item["details"]!: "",
                      base64Image: "",
                      itemCodes: Provider.of<ComponentProvider>(context, listen: false).getInstanceCodesForItemId(item["item id"]),
                      colors: colors,
                      numberOfAvailableItems: int.parse(qty),
                      )
                  ),
              ],
            ),
          );
        },
      ),

      )
    
    );
  }
}