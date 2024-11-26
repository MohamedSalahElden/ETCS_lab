import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemDetailsCard extends StatelessWidget {
  final Map<String , dynamic> item; 
  final String itemName; 
  final String itemId; 
  final String itemDetails;
  final String base64Image; 
  final Map<String , Color> colors;
  final int numberOfAvailableItems;
  List<String> itemCodes = [];

  List<String> selectedItemsToBorrow = [];
  
  
  // Constructor to accept the itemName
   ItemDetailsCard(
    {Key? key, required this.item , required this.itemName,required this.itemId, required this.base64Image, required this.itemDetails , required this.colors , required this.numberOfAvailableItems}
  ) : super(key: key);


  // recolor the icons based on category
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


  void showItemDialog(BuildContext context) {
    
    itemCodes = Provider.of<ComponentProvider>(context, listen: false).getAllComponentCodesForItemId(itemId);
    
    
    Map<String, bool> selectedItems = {
      for (var item in itemCodes) item: false,
    };
    
       
    showDialog(
    context: context,

    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                  'Which $itemName ?',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 16.0),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: selectedItems.entries.map((entry) {
                      return CheckboxListTile(
                        title: Text(entry.key),
                        value: entry.value,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedItems[entry.key] = value ?? false;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 42, 153, 27), 
                          checkColor: Colors.white,
                        );
                      }).toList(),
                  ),
                ),
                const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity, 
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 42, 153, 27),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        List<String> selected = selectedItems.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList();
                        for (var s in selected) {
                          itemCodes.remove(s);  
                        }
                        await Provider.of<ComponentProvider>(context, listen: false).borrowComponent(selected);

                        
                      },
                      child: const Text('Borrow'),
                    ),
                  ),

                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54, // Text color
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    print("[expanded] $item ");
    return Container(
      color: colors["itemColor"],
      child:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (base64Image != '') 
          Image.asset(
            'assets/cert_header.png',
            width: 150,
            height: 150,
          ),
        
        
        
        Container(
          width: double.infinity, // Make the container take the full width of the parent
          
          child : SingleChildScrollView(
          scrollDirection: Axis.horizontal, 
          
          child:  Row(
            // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            children: 
            [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, 
              
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(width: 8),
                Chip(
                  label: Text("Total: ${item['quantity']}" , style: TextStyle(color: Colors.white) ),
                  backgroundColor:  const Color(0xffbf1e2e),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Set the desired radius
                  ),
                  side: BorderSide.none,
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text(item['type'] , style: TextStyle(color: getCategoryColor(item['type'])),),
                  backgroundColor:  const Color.fromARGB(0, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Set the desired radius
                  ),
                  side: BorderSide(
                    color: getCategoryColor(item['type']),  // Border color
                    width: 2.0,          // Border thickness
                  ),
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text(item['technology'] , style: TextStyle(color: getCategoryColor(item['technology'])),),
                  backgroundColor:  const Color.fromARGB(0, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Set the desired radius
                  ),
                  side: BorderSide(
                    color: getCategoryColor(item['technology']),  // Border color
                    width: 2.0,          // Border thickness
                  ),
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text(item['section'] , style: TextStyle(color: getCategoryColor(item['section'])),),
                  backgroundColor:  const Color.fromARGB(0, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Set the desired radius
                  ),
                  side: BorderSide(
                    color: getCategoryColor(item['section']),  // Border color
                    width: 2.0,          // Border thickness
                  ),
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text(item['related to'] , style: TextStyle(color: getCategoryColor(item['related to'])),),
                  backgroundColor:  const Color.fromARGB(0, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Set the desired radius
                  ),
                  side: BorderSide(
                    color: getCategoryColor(item['related to']),  // Border color
                    width: 2.0,          // Border thickness
                  ),
                ),
                ],
              ),
            
              ),

            
            ),
            ]
          ),
        
          ),
        ),

        if(item["details"] != '')
        Container(
          width: double.infinity, // Make the container take the full width of the parent
          child : Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 10),

              child : SingleChildScrollView(
                scrollDirection: Axis.horizontal, 
                child: Text(item["details"]),
                ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Small Icon Button
            Flexible(
              flex: 1, // Small portion of the available space
              child: ElevatedButton(
                onPressed: () {
                  // More Details Button Logic
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('More Details'),
                      content: const Text('Details about the item go here.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8), // Adjust padding for a smaller button
                  shape: const CircleBorder(), // Circular shape for the button
                  backgroundColor: const Color.fromARGB(255, 175, 175, 175), // Background color for the icon button
                ),
                child: const Icon(Icons.info, size: 24 , color: Colors.white,), // Small icon
              ),
            ),
            const SizedBox(width: 16), // Space between buttons
            // Borrow Button
            Expanded(
              flex: 5, // Remaining width of the row
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors["logoColor"], // White text
                ),
                onPressed: () async {
                  if (numberOfAvailableItems > 0){
                    showItemDialog(context);
                  }  
                },
                child:  Text('Borrow' , style: TextStyle(color: colors["itemColor"]),),
              ),
            ),
          ],
        )

      ],
    )
    );
  }
}
