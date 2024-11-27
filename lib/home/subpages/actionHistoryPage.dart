import 'package:etcs_lab_manager/signin_up/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final String instanceCode;

  ChatPage({Key? key, required this.item, required this.instanceCode})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final List<Message> messages = [
  //   Message(sender: "mohamed salah", actionType: "borrow" ,text: "", timestamp: "10:00 AM"),
  //   Message(sender: "mohamed salah", actionType: "return" ,text: "Hello! How are you?", timestamp: "10:00 AM"),
  //   Message(sender: "You", actionType: "borrow", text: "I'm good, thanks! How about you?", timestamp: "10:01 AM"),
  //   Message(sender: "You", actionType: "return", text: "I'm doing well. What are you up to?", timestamp: "10:02 AM"),
  //   Message(sender: "george safwat", actionType: "borrow", text: "Just working on some Flutter projects.", timestamp: "10:03 AM"),
  //   Message(sender: "george safwat", actionType: "return", text: "Sounds interesting! Keep it up.", timestamp: "10:05 AM"),
  //   Message(sender: "mina girgis", actionType: "borrow", text: "Just working on some Flutter projects.", timestamp: "10:03 AM"),
  //   Message(sender: "mina girgis", actionType: "return", text: "Sounds interesting! Keep it up.", timestamp: "10:05 AM"),

  // ];
  bool isAtEnd = false;

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _messageController = TextEditingController();
  String _selectedOption = "Damaged";
  final List<String> _options = ["Damaged", "Reconfigure", "Set Value"];

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Color getCategoryColor(String category) {
    if(category == "borrow"){return Color.fromARGB(255, 42, 153, 27);}
    else if(category == "return"){return Color(0xffbf1e2e);}
    else if(category == "Damaged"){return Colors.black;}
    else{
      int hash = category.hashCode;
      int red = (hash & 0xFF0000) >> 16;
      int green = (hash & 0x00FF00) >> 8;
      int blue = hash & 0x0000FF;
      return Color.fromARGB(255, red, green, blue);
    }
    
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    await Provider.of<ComponentProvider>(context, listen: false).addAction(widget.instanceCode , _selectedOption , "title" , text);
    if (text.isNotEmpty) {
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final componentProvider =
        Provider.of<ComponentProvider>(context, listen: true);
    print("[comp] ${componentProvider.itemActions}");

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
          padding:
              const EdgeInsets.all(0), // Padding to give space from the left
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the left
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
                widget.instanceCode,
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
                controller: _scrollController,
                itemCount: componentProvider.itemActions.length,
                reverse: false,
                itemBuilder: (context, index) {
                  final action = componentProvider.itemActions[index];
                  final user = FirebaseAuth.instance.currentUser;
                  String userUID = "";
                  if (user != null) {
                    userUID = user.uid;
                  }
                  final isMe = action["action user ID"] == userUID;
                  String initials = "";
                  String user_name = action["action owner name"];
                  if (!isMe) {
                    List<String> nameParts = user_name.split(" ");
                    if (nameParts.length < 2) {
                      initials = nameParts[0][0];
                    } else {
                      initials = nameParts[0][0] + nameParts[1][0];
                    }
                  }

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
                                initials,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: getCategoryColor(user_name),
                            ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(action["action type"],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10)),
                            backgroundColor: getCategoryColor(action["action type"]),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Set the desired radius
                            ),
                            side: BorderSide.none,
                          ),
                        ],
                      ),
                      if (action["date"] != "")
                        Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Text(
                            action["date"],
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      SizedBox(height: 4.0),
                      // Message Bubble
                      if (action["action title"] != "")
                        Padding(
                          padding: EdgeInsets.only(left: 40),
                          child: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2), // Shadow color
                                    blurRadius: 6.0, // Spread of the shadow
                                    offset:
                                        Offset(0, 3), // Offset of the shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    action["action details"],
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
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
                    decoration: const InputDecoration(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: TextField(
                          controller: _messageController,
                          keyboardType: TextInputType
                              .multiline, // Allows multi-line input
                          maxLines: null, // Expands to fit text
                          minLines: 1, // Initial height
                          decoration: const InputDecoration(
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
  final String actionType;

  Message(
      {required this.sender,
      required this.text,
      required this.timestamp,
      required this.actionType});
}
