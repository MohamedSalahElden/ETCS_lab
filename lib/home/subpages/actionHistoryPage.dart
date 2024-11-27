import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final String instanceCode;

  ChatPage({Key? key, required this.item, required this.instanceCode}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> messages = [
    Message(sender: "Other", text: "Hello! How are you?", timestamp: "10:00 AM"),
    Message(sender: "You", text: "I'm good, thanks! How about you?", timestamp: "10:01 AM"),
    Message(sender: "Other", text: "I'm doing well. What are you up to?", timestamp: "10:02 AM"),
    Message(sender: "You", text: "Just working on some Flutter projects.", timestamp: "10:03 AM"),
    Message(sender: "Other", text: "Sounds interesting! Keep it up.", timestamp: "10:05 AM"),
  ];

  final TextEditingController _messageController = TextEditingController();
  String _selectedOption = "Damaged";
  final List<String> _options = ["Damaged", "Reconfigure", "Set Value"];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(Message(
          sender: "You",
          text: "$_selectedOption: $text",
          timestamp: "Now",
        ));
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xffbf1e2e), Color.fromARGB(255, 137, 15, 28)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  title: Padding(
    
    padding: const EdgeInsets.all(0),  // Padding to give space from the left
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,  // Align text to the left
      children: [
        Text(
          widget.item["item name"] ?? "Default Title",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          widget.instanceCode ?? "Default Instance Code",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
      ],
    ),
  ),
),

    

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                reverse: false,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe = message.sender == "You";

                  return Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isMe)
                            CircleAvatar(
                              radius: 16.0,
                              child: Text(
                                "M",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                          SizedBox(width: 8.0),
                          Text(
                            "For now fill it with Title",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      // Message Bubble
                      Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          constraints: BoxConstraints(maxWidth: 250.0),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                message.timestamp,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Dropdown and Text Input Section
            Column(
              children: [
                // Dropdown List
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[200],
                  //   borderRadius: BorderRadius.circular(12.0),
                  //   border: Border.all(color: Colors.grey[400]!),
                  // ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedOption,
                    items: _options.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Select Action",
                      labelStyle: TextStyle(fontSize: 14.0),
                    ),
                    isExpanded: true,
                  ),
                ),
                // Message Input and Send Button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        
                        
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(color: Colors.grey[400]!),
                          
                          
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        child: TextField(
                          
                          controller: _messageController,
                          keyboardType: TextInputType.multiline, // Allows multi-line input
                          maxLines: null, // Expands to fit text
                          minLines: 1, // Initial height
                          decoration: InputDecoration(
                            hintText: "Write your action deatils...",
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.blue,
                      //   borderRadius: BorderRadius.circular(15.0),
                      // ),
                      child: IconButton(
                        icon: Icon(Icons.add, color: Color(0xffbf1e2e)),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String sender;
  final String text;
  final String timestamp;

  Message({required this.sender, required this.text, required this.timestamp});
}
