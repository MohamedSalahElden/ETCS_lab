import 'package:etcs_lab_manager/home/subpages/itemdetailscard.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllItems extends StatefulWidget {

  // list that contains all items
  final List<Map<String, dynamic>> all_items; 

  const AllItems({Key? key, required this.all_items}) : super(key: key);

  @override
  _AllItemsState createState() => _AllItemsState();


}

late Function(bool) globalUpdateFunction;

class _AllItemsState extends State<AllItems> {
  
  int? _expandedIndex; // Track the currently expanded item index
  bool _isSearch = false;
  // change colors base on item availability
  Map<String, Color> getItemAvailabilityColor(int numberOfItems, String category) {
    Color iconColor = getCategoryColor(category);
    if (numberOfItems > 0) {
      return {
        "textColor": const Color.fromARGB(255, 0, 0, 0),
        "itemColor": const Color.fromARGB(255, 255, 255, 255),
        "circleColor": iconColor,
        "logoColor": const Color.fromARGB(255, 42, 153, 27),
      };
    } else {
      return {
        "textColor": const Color.fromARGB(255, 174, 174, 174),
        "itemColor": const Color.fromARGB(255, 229, 229, 229),
        "logoColor": const Color.fromARGB(255, 174, 174, 174),
        "circleColor": const Color.fromARGB(255, 174, 174, 174),
      };
    }
  }

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


@override
void initState() {
  super.initState();
  globalUpdateFunction = setIsSearch; // Store the function reference
}

void setIsSearch(bool value) {
    setState(() {
      _isSearch = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    final componentProvider = Provider.of<ComponentProvider>(context, listen: true);
    List<Map<String , dynamic>> allComponents = [{}];
    if (_isSearch == true){
       allComponents = componentProvider.componentsToView;
       print("[search] get data from compenetnsToView");
    }
    else if (_isSearch == false){
      allComponents = componentProvider.allComponents;
      print("[search] getting data from allComponents");
    }
    


    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          // reload the list of all components
          await Provider.of<ComponentProvider>(context, listen: false).initializeComponents();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: allComponents.length,
          itemBuilder: (context, index) {
            final isExpanded = _expandedIndex == index;
            final item = allComponents[index];
            final quantity = int.parse(item["inLabComponents"]?.toString() ?? "0");
            final colors = getItemAvailabilityColor(quantity , item["section"]);
            return buildItemCard(item, quantity , colors, isExpanded, index);
          },
        ),
      ),
    );
  }

  Widget buildItemCard(
    Map<String, dynamic> item, 
    int inLabQuantity ,
    Map<String, Color> colors, 
    bool isExpanded, 
    int index
    )
    {
    
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
              child: Text(
                item["section"]?.substring(0, 2) ?? "",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              item["item name"] ?? "undefined name",
              style: TextStyle(fontWeight: FontWeight.bold, color: colors["textColor"]),
            ),
            subtitle: Text(
              "$inLabQuantity items in lab",
              style: TextStyle(color: colors["textColor"]),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ItemDetailsCard(
                item: item,
                itemName  : item["item name"] ?? "",
                itemId    : item["item id"] ?? "",
                itemDetails: item["details"] ?? "",
                base64Image: "",
                colors: colors,
                numberOfAvailableItems: inLabQuantity,
              ),
            ),
        ],
      ),
    );
  }
}
