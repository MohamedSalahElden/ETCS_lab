import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ItemDetailsCard extends StatelessWidget {
  final String itemName; // Field to hold the passed string value
  final String itemDetails;
  final String base64Image; 
  final List<String> itemCodes;
  final Map<String , Color> colors;
  final int numberOfAvailableItems;
  List<String> selectedItemsToBorrow = [];
  // Constructor to accept the itemName
   ItemDetailsCard(
    {Key? key, required this.itemName, required this.base64Image, required this.itemCodes, required this.itemDetails , required this.colors , required this.numberOfAvailableItems}
  ) : super(key: key);


void showItemDialog(BuildContext context) {
  // A map to track selected items
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
              width: MediaQuery.of(context).size.width * 0.8, // Set the dialog width
              padding: const EdgeInsets.all(16.0), // Add padding for better styling
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                  'which $itemName',
                  style: Theme.of(context).textTheme.titleLarge,
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
                          activeColor: const Color.fromARGB(255, 42, 153, 27), // Checked color
                          checkColor: Colors.white, // Checkmark color
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity, // Full-width button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 42, 153, 27), // Green background
                        foregroundColor: Colors.white, // White text
                      ),
                      onPressed: () async {
                        // Process selected items
                        List<String> selected = selectedItems.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList();
                        selectedItemsToBorrow = selected;
                        for (var itemCode in selected) {
                          await Provider.of<ComponentProvider>(context, listen: false).borrowComponent(itemCode);
                        }
                        print('[salah] Selected items: $selectedItemsToBorrow');
                        Navigator.of(context).pop();
                      },
                      child: const Text('Borrow'),
                    ),
                  ),
                  const SizedBox(height: 8.0), // Spacing between buttons
                  SizedBox(
                    width: double.infinity, // Full-width button
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54, // Text color
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('CANCEL'),
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
    
    return
    
    Container(
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
        
        if (itemDetails != '') 
        const SizedBox(height: 16),
        
        if (itemDetails != '') 
          Text(
            this.itemDetails,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        if (itemDetails != '')
        const SizedBox(height: 16),
        
        // Buttons
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
                  if (numberOfAvailableItems>0){
                    showItemDialog(context);
                    
                    // Borrow Button Logic
                    // print("[salah] borrowing component with code 18b78bb21b5f0101");
                    // await Provider.of<ComponentProvider>(context, listen: false).borrowComponent("18b78bb21b5f0101");
                    
                    // view message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item borrowed successfully!'),
                      ),
                    );
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
