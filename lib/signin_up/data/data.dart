import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuzzy/fuzzy.dart';

class ComponentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>>  allComponents = [];
  List<Map<String, dynamic>>  componentsToView = [];
  Map<String, dynamic>  userComponentsToView = {};
  Map<String, dynamic> userComponents = {};


void searchOnUserComponents( searchString){
    userComponentsToView = {};
    Map<String , dynamic> copyOfUserComponents = userComponents;
    List<String> keys = copyOfUserComponents.keys.toList();
    List<String> items = copyOfUserComponents.values
                            .map((item) => item['item_name'] as String)
                            .where((itemName) => itemName != null) // Optional: Ensure no null values
                            .toList();
    List<Map<String, dynamic>> interrist_components = [];
    
    final fuzzy = Fuzzy(items);
    final results = fuzzy.search(searchString);
    for (var r in results) {
      int index  = r.matches[0].arrayIndex;
      Map<String, dynamic> item  = copyOfUserComponents[keys[index]];
      userComponentsToView[keys[index]] = {
                'item_name': item['item_name'],
                'unique_code': keys[index],
                'borrowed_by': item['borrowed_by'],
                'status': item['status'],
                'date_borrowed': item['date_borrowed'],
              };
    }
    
    notifyListeners();
  }



  void searchOnAllComponents(searchString){
    List<Map<String , dynamic>> ListOfitems = allComponents;
    List<String> items = ListOfitems.map((item) => item['item name'] as String).toList();
    List<Map<String, dynamic>> interrist_components = [];
    
    final fuzzy = Fuzzy(items);
    final results = fuzzy.search(searchString);
    for (var r in results) {
      int index  = r.matches[0].arrayIndex;
      interrist_components.add(allComponents[index]);
    }
    componentsToView = interrist_components;
    notifyListeners();
  }
  

  // Firebase setup should be added here (e.g., FirebaseFirestore instance).

  Future<void> refreshAll() async{
    initializeComponents();
    fetchBorrowedItems();
    notifyListeners();
  }



  void printmessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT, // Toast duration: short or long
        gravity: ToastGravity.BOTTOM,   // Position: bottom, center, or top
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),  // Background color
        textColor: Colors.white,        // Text color
        fontSize: 10.0,                 // Font size
      );
  }


  Future<void> initializeComponents() async {
    // Fetch all components from Firebase
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('items')
          .get();

      // Update the list of items
      allComponents = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      print("Fetched delivered items: $allComponents");

      // Notify listeners to rebuild UI or update dependent state
      notifyListeners();
    } catch (e) {
      print('Error fetching data: $e');
    }
    componentsToView = allComponents;
  
    notifyListeners();
  }

  Future<void> fetchBorrowedItems() async {
  
  final user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    if (user != null) {
      final userUID = user.uid;
      userComponents = {};

      // Query the items collection
      QuerySnapshot itemsSnapshot = await firestore.collection('items').get();

      // Iterate through each document in the items collection
      for (var doc in itemsSnapshot.docs) {
        Map<String, dynamic> itemData = doc.data() as Map<String, dynamic>;
        print("[salah] [doc] $doc");
        // Check if 'instances' exists and is a Map
        if (itemData['instances'] is Map<String, dynamic>) {
          Map<String, dynamic> instances = itemData['instances'];

          // Iterate through the entries of the 'instances' map
          instances.forEach((uniqueCode, instanceData) {
            if (instanceData['borrowed_by'] == userUID) {

              userComponents[uniqueCode] = {
                'item_name': itemData['item name'],
                'unique_code': uniqueCode,
                'borrowed_by': instanceData['borrowed_by'],
                'status': instanceData['status'],
                'date_borrowed': instanceData['date_borrowed'],
              };

              print("[salah] [user components] $userComponents");
            }
          });
        }
      }
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
  
  notifyListeners();
}

  Future<bool> isBorrowed(String componentCode)async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String itemId = componentCode.substring(0,12);
      try{
        DocumentSnapshot itemDoc = await firestore.collection('items').doc(itemId).get();

        if (itemDoc.exists) {
          Map<String, dynamic> itemData = itemDoc.data() as Map<String, dynamic>;
          if (itemData["instances"][componentCode]["borrowed_by"] == ""){
            
            return false;
          }
          else{
            print("[salah] [isBorrowed] $componentCode is borrowed by ${itemData["instances"][componentCode]["borrowed_by"] }");
            return true;
            
          }
        }
      }
      catch(e){
        print("error while checking for $componentCode");
        return false;
      }
      return false;
  }

  Future<void> borrowComponent(List<String> componentCodeList) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    int numberOfSuccessfullyBorrowedItems = 0;
    
    for (var componentCode in componentCodeList) {
      String itemId = componentCode.substring(0, 12);
      try{
        if (user != null) {
          final userUID = user.uid;
            if (isBorrowed(componentCode) == true){}
            else{
              await firestore.collection('items').doc(itemId).update({
                'instances.$componentCode.borrowed_by': userUID,
                'inLabComponents': FieldValue.increment(-1), // Decrease the count by 1
              });
              printmessage("item $componentCode borrowed successfully");
              numberOfSuccessfullyBorrowedItems += 1;
            } 
          }
          else{ // no user logged in
            printmessage("no user logged in!");
          }
        }catch(e) {
          printmessage("error occured");
        }  
    }
    if (numberOfSuccessfullyBorrowedItems == componentCodeList.length){
    }
    else{
      printmessage("not all components was successfully borrowed");
    }
    fetchBorrowedItems();
    initializeComponents();
    
}

  Future<void> returnComponent(String componentCode) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String itemId = componentCode.substring(0, 12);

  try {
    // Update the borrowed_by field for the specific instance and increment inLabComponents
    await firestore.collection('items').doc(itemId).update({
      'instances.$componentCode.borrowed_by': "", // Clear the borrowed_by field
      'inLabComponents': FieldValue.increment(1),  // Increment the inLabComponents count by 1
    });

    print('Borrowed_by field cleared successfully.');

    // Optionally call fetchBorrowedItems() to refresh the borrowed items list
    // fetchBorrowedItems();

    // Notify listeners after returning the component
    notifyListeners();
  } catch (e) {
    print('Error updating borrowed_by: $e');
  }

  print("Component $componentCode returned successfully.");
  initializeComponents(); // Reinitialize components as necessary
}
  
  List<String> getAllComponentCodesForItemId(String itemId) {
  initializeComponents();
  
  // Find the item with the specified item ID, allowing for null if not found
  final item = allComponents.firstWhere(
    (element) => element["item id"] == itemId,
    orElse: () => <String, dynamic>{}, // Return an empty map if not found
  );

  // If item is empty, return an empty list
  if (item.isEmpty) {
    return [];
  }

  // Extract and return the unique codes (keys of the instances map)
  List<String> componentCodes = (item["instances"] as Map<String, dynamic>)
      .entries
      .where((entry) => entry.value['borrowed_by'] == '') // Filter where 'borrowed_by' is ''
      .map((entry) => entry.key) // Get the key (unique code)
      .toList();

 
  print("[salah] [getAllComponentCodesForItemId] $componentCodes");
  initializeComponents();
  notifyListeners();
  return componentCodes;
}

  Map<String, dynamic> getItemFromInstance(String instanceCode) {
  print("[salah] function called");
  String itemId = instanceCode.substring(0, 12);
  Map<String, dynamic>? item = allComponents.firstWhere(
    (component) => component['item id'] == itemId,
    orElse: () => {}, // You can return an empty map if no match is found
  );
  return item;

}  

}






































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class DataService extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Holds the fetched items
//   List<Map<String, dynamic>> _allItems = [];

//   // Accessor to retrieve the items
//   List<Map<String, dynamic>> get allItems => _allItems;

//   // Fetch delivered items
//   Future<void> getDeliveredItems() async {
//     print("############################################################");
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('items')
//           .where('Status', isEqualTo: 'DELIVERED')
//           .get();

//       // Update the list of items
//       _allItems = querySnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();

//       print("Fetched delivered items: $_allItems");

//       // Notify listeners to rebuild UI or update dependent state
//       notifyListeners();
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }
// }
