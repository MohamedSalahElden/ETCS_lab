import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ComponentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>>  allComponents = [];
  List<Map<String, dynamic>> userComponents = [];
  

  // Firebase setup should be added here (e.g., FirebaseFirestore instance).

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
  
    notifyListeners();
  }


  Future<void> fetchBorrowedItems() async {
    userComponents = [];
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the items collection
    QuerySnapshot itemsSnapshot = await firestore.collection('items').get();


    // Fetch components owned by the user from Firebase
     try {
      if (user != null) {
        final userUID = user.uid;

        // Reference to the user's document
        for (var doc in itemsSnapshot.docs) {
          Map<String, dynamic> itemData = doc.data() as Map<String, dynamic>;
          
          // Iterate through the 'instances' field to check if any instance is borrowed by the user
          List instances = itemData['instances'];
          for (var instance in instances) {
            if (instance['borrowed_by'] == userUID) {
              userComponents.add({
                'item_name': itemData['item name'],
                'unique_code': instance['unique_code'],
                'borrowed_by': instance['borrowed_by'],
                'status': instance['status'],
                'date_borrowed': instance['date_borrowed'],
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    notifyListeners();
  }

  Future<void> borrowComponent(String componentCode) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    String itemId = componentCode.substring(0, 12);

  // Fetch components owned by the user from Firebase
    try {
    if (user != null) {
      final userUID = user.uid;

      try {
      // Get the document for the specific item
      DocumentSnapshot itemDoc = await firestore.collection('items').doc(itemId).get();

        if (itemDoc.exists) {
          Map<String, dynamic> itemData = itemDoc.data() as Map<String, dynamic>;

          // Find the instance with the matching unique_code
          List instances = itemData['instances'];
          int instanceIndex = instances.indexWhere((instance) => instance['unique_code'] == componentCode);

          if (instanceIndex != -1) {
            // Update the borrowed_by field for the matching instance
            instances[instanceIndex]['borrowed_by'] = userUID;            
            // Update the document in Firestore
            await firestore.collection('items').doc(itemId).update({
              'instances': instances,
            });


            int number = itemData['inLabComponents'] - 1;
            await firestore.collection('items').doc(itemId).update({
              'inLabComponents': number,
            });


            // userComponents.add({
            //     'item_name': itemData['item name'],
            //     'unique_code': instances[instanceIndex]['unique_code'],
            //     'borrowed_by': instances[instanceIndex]['borrowed_by'],
            //     'status': instances[instanceIndex]['status'],
            //     'date_borrowed': instances[instanceIndex]['date_borrowed'],
            // });
            fetchBorrowedItems();

            print("[salah] component $componentCode has beed borrowed by $userUID" );
          } else {
            print('[salah] No instance found with unique code $componentCode');
          }
        } 
        else {
          print('[salah] Item not found');
        }
      } catch (e) {
        print('[salah] Error updating borrowed_by: $e');
      }
    }
    } catch (e) {
      print('[salah] Error fetching data: $e');
    }
  

  // fetchBorrowedItems();
  notifyListeners();

  }

  Future<void> returnComponent(String componentCode) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String itemId = componentCode.substring(0, 12);
    try {
      // Get the document for the specific item
      DocumentSnapshot itemDoc = await firestore.collection('items').doc(itemId).get();

      if (itemDoc.exists) {
        Map<String, dynamic> itemData = itemDoc.data() as Map<String, dynamic>;

        // Find the instance with the matching unique_code
        List instances = itemData['instances'];
        int instanceIndex = instances.indexWhere((instance) => instance['unique_code'] == componentCode);

        if (instanceIndex != -1) {
          // Update the borrowed_by field for the matching instance
          instances[instanceIndex]['borrowed_by'] = "";
          // Update the document in Firestore
          await firestore.collection('items').doc(itemId).update({
            'instances': instances,
          });

          int number = itemData['inLabComponents'] + 1 ;
          await firestore.collection('items').doc(itemId).update({
            'inLabComponents': number,
          });



          print('Borrowed_by field updated successfully.');
        } else {
          print('No instance found with unique code $componentCode');
        }
      } else {
        print('Item not found');
      }
    } catch (e) {
      print('Error updating borrowed_by: $e');
    }
    print("return component $componentCode");
    initializeComponents();
    // fetchBorrowedItems();
    notifyListeners();

  }

  
  List<String> getInstanceCodesForItemId(String itemId) {
  initializeComponents();
  // Find the item with the specified item ID, allowing for null if not found
  final item = allComponents.firstWhere(
    (element) => element["item id"] == itemId,
    orElse: () => <String, dynamic>{}, // Return an empty map instead of null
  );

  // If item is empty, return an empty list
  if (item.isEmpty) {
    return [];
  }
  dynamic x = (item["instances"] as List<dynamic>)
    .where((instance) => instance["borrowed_by"] == '')
    .map((instance) => instance["unique_code"] as String)
    .toList();

  // dynamic x = (item["instances"] as List<dynamic>)
  //     .map((instance) => instance["unique_code"] as String)
  //     .toList();
  // Extract and return the unique codes of all instances
  notifyListeners();
  print(x);
  return x;
  
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
