import 'package:etcs_lab_manager/home/subpages/actionHistoryPage.dart';
import 'package:etcs_lab_manager/home/subpages/itemCard.dart';
import 'package:etcs_lab_manager/home/subpages/itemEditing.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemDetailsPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const ItemDetailsPage({super.key, required this.item});

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  
  @override
  Widget build(BuildContext context) {
  final componentProvider = Provider.of<ComponentProvider>(context, listen: true);
    List<String> instanceKeys = widget.item["instances"].keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item["item name"] ?? "Item Details",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xffbf1e2e),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mode_edit_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ModifyDataScreen()),
                  );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0), // Space below the AppBar
        child: ListView(
          children: [
            ItemCard(item: widget.item),
            buildDetailRow(
              icon: Icons.info,
              title: "Item Id",
              content: widget.item["item id"] ?? "N/A",
            ),
            buildDetailRow(
              icon: Icons.link,
              title: "Link",
              content: widget.item["link"] ?? "N/A",
            ),
            buildDetailRow(
              icon: Icons.numbers_outlined,
              title: "Available in lab",
              content: '${widget.item["inLabComponents"].toString()} out of ${widget.item["quantity"].toString()}',
            ),
            const SizedBox(height: 16.0), // Space before the scrollable list

            // Scrollable section for additional data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Instances",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            
            ListView.builder(
              shrinkWrap: true, // Required for embedding in a ListView
              physics: const NeverScrollableScrollPhysics(), // Prevents nested scroll issues
              itemCount: instanceKeys.length,
              itemBuilder: (context, index) {
                final instance = widget.item["instances"][index];
                print("[instance] ${instanceKeys[index]}");
                bool isBorrowed = widget.item["instances"][instanceKeys[index]]["borrowed_by"] != "";
                bool isWorking = widget.item["instances"][instanceKeys[index]]["working_status"] == "working";
                return 
              Card(
                  elevation: 4.0, // Elevation value
                  color: Colors.white,
                  shadowColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5), // Shadow color
                  // borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  child: ListTile(
                    leading: Icon(
                      Icons.memory,
                      color: isBorrowed
                          ? Colors.black45
                          : const Color.fromARGB(255, 42, 153, 27),
                    ),
                    title: Text(instanceKeys[index]),
                    subtitle: Text(
                      isBorrowed ? "Borrowed" : "Not Borrowed",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: isBorrowed
                            ? const Color.fromARGB(255, 42, 153, 27)
                            : Colors.black54,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isWorking ? "working" : "damaged",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: isWorking
                                ? const Color.fromARGB(255, 42, 153, 27)
                                : const Color(0xffbf1e2e),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  ChatPage(item: widget.item ,  instanceCode: instanceKeys[index])),
                            );
                          },
                          icon: const Icon(Icons.history),
                          color: Colors.grey,
                        ),
                        IconButton(
                          onPressed: () async {
                            await Provider.of<ComponentProvider>(context, listen: false).borrowComponent([ instanceKeys[index]]);
                          },
                          icon: const Icon(Icons.file_download_outlined),
                          color: isBorrowed? Colors.grey : const Color.fromARGB(255, 42, 153, 27) ,
                        ),
                      ],
                    ),
                  ),
                );

              
              },
            ),
            
          ],
          
        ),
      ),
    );
  }

  Widget buildDetailRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.0, color: const Color(0xffbf1e2e)),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
