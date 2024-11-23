import 'package:flutter/material.dart';

class ItemDetailsTable extends StatelessWidget {
  // Define a list of items with names and technologies
  final List<Map<String, dynamic>> items = [
    {
      'name': 'Item 1',
      'technologies': ['Flutter', 'Dart', 'Firebase']
    },
    {
      'name': 'Item 2',
      'technologies': ['React', 'Node.js', 'MongoDB']
    },
    {
      'name': 'Item 3',
      'technologies': ['Python', 'Django', 'PostgreSQL']
    },
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row with the item name
                  Text(
                    item['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8), // Space between rows
                  // Second row with the technologies
                  Wrap(
                    spacing: 8, // Spacing between chips
                    children: item['technologies'].map<Widget>((tech) {
                      return Chip(
                        label: Text(tech),
                        backgroundColor: Colors.blueAccent,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}
