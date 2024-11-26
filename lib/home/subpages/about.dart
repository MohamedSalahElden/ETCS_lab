import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final List<AboutItem> aboutItems = [
    AboutItem(
      icon: Icons.person,
      title: "Name",
      content: "Mohamed Salah-El-Den",
    ),
    AboutItem(
      icon: Icons.work,
      title: "Profession",
      content: "Senior Embedded Systems Engineer",
    ),
    AboutItem(
      icon: Icons.school,
      title: "Education",
      content: "B.Sc. in Communication and Electronics Engineering",
    ),
    AboutItem(
      icon: Icons.email,
      title: "Email",
      content: "mohamed@example.com",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen
          },
        ),
      ),
      body: ListView.builder(
        itemCount: aboutItems.length,
        itemBuilder: (context, index) {
          final item = aboutItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.icon, size: 24.0, color: Colors.blue),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        item.content,
                        style: TextStyle(
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
        },
      ),
    );
  }
}

class AboutItem {
  final IconData icon;
  final String title;
  final String content;

  AboutItem({required this.icon, required this.title, required this.content});
}
