
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemCard extends StatelessWidget {
  final Map<String , dynamic> item; 

  
  const ItemCard({super.key, required this.item , });

  Color getCategoryColor(String category) {
    int hash = category.hashCode;
    int red = (hash & 0xFF0000) >> 16; 
    int green = (hash & 0x00FF00) >> 8; 
    int blue = hash & 0x0000FF;
    return Color.fromARGB(255, red, green, blue);
  }


void _launchURL(String query) async {
  // query = query.replaceAll(' ', '+');
  final Uri url = Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent(query)}');
  if (await canLaunchUrl(url)) {  // Check if the URL can be launched
    await launchUrl(url);  // Launch the URL
  } else {
    print('Could not launch $url');
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        // ___________ image ______________ //
        if (item["base64image"] != '') 
          Image.asset( 'assets/cert_header.png', width: 150,height: 150,),
        

        // ___________ Tags ______________ //
        SizedBox(
          width: double.infinity, // Make the container take the full width of the parent
          child : SingleChildScrollView(
            scrollDirection: Axis.horizontal, 
            child:  Row(
              // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: 
              [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, 
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 

                        IconButton(
  icon: Container(
    child: SizedBox(
      width: 30.0,  // Adjust the width
      height: 30.0, // Adjust the height
      child: Image.asset('assets/google_PNG19635.png',
        fit: BoxFit.cover,
      ),
    ),
  ),
  onPressed: () {
    _launchURL(item['item name']);
  },
),
















                        // 
                        const SizedBox(width: 8),
                        Chip(
                          label: Text("Total: ${item['quantity']}" , style: TextStyle(color: Colors.white) ),
                          backgroundColor:  const Color(0xffbf1e2e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Set the desired radius
                          ),
                          side: BorderSide.none,
                        ),
                        const SizedBox(width: 8),
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
                        const SizedBox(width: 8),
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
                        const SizedBox(width: 8),
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
                        const SizedBox(width: 8),
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
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),  
            child: Text(item["details"]),
          ),
        ),
        
        
        
      ],
    )
    );
  }
}





