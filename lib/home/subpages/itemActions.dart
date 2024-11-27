import 'package:etcs_lab_manager/home/subpages/actionHistoryPage.dart';
import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemActions extends StatelessWidget {
  final Map<String, dynamic> item;
  final String bottonState;
  final String bottonType;
  final String instanceCode;
  final VoidCallback action;

  const ItemActions({super.key, required this.item, required this.bottonState,required this.bottonType , required this.action , required this.instanceCode });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0), // Add padding around the card
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Buttons Row: Icon Button + Full-Width Borrow Button
          Row(
            children: [
              // Small Icon Button
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<ComponentProvider>(context, listen: false).getActions(instanceCode);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ChatPage(item: item ,  instanceCode: instanceCode)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8), // Adjust padding for a smaller button
                  shape: const CircleBorder(), // Circular shape for the button
                  backgroundColor: const Color.fromARGB(255, 175, 175, 175), // Button color
                ),
                child: const Icon(Icons.info, size: 24, color: Colors.white), // Info icon
              ),
              const SizedBox(width: 16), // Space between the buttons
              bottonWithState(bottonState , bottonType),
            ],
          ),
        ],
      ),
    );
  }

  Expanded bottonWithState(bottonType , bottonState){
  // Full-width Borrow Button
              if(bottonState == "borrow"){
              return Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners for the button
                    ),
                    backgroundColor: bottonType == "active"
                      ? Color.fromARGB(255, 42, 153, 27) // Color for active state
                      : const Color(0xffa9a9a9), // Color for inactive state
                     // Use theme's primary color
                  ),
                  onPressed: action,
                  child: const Text(
                    'borrow',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );}

              else if(bottonState == "return"){
              return Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners for the button
                    ),
                    backgroundColor: bottonType == "active"
                      ? const Color(0xffbf1e2e) // Color for active state
                      : const Color(0xffa9a9a9), // Color for inactive state
                  ),
                  onPressed: action,
                  child: const Text(
                    'Return to lab',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );}

              
              else{
                return Expanded(child: Text("error"));
              }
  }




}


