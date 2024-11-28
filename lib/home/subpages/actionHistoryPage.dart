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
  bool hasFetchedActions = false;
  bool scrolled = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedOption = "Damaged";
  final List<String> _options = ["Damaged", "Reconfigure", "Set Value"];

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Color getCategoryColor(String category) {
    if (category == "borrow") {
      return Color.fromARGB(255, 42, 153, 27);
    } else if (category == "return") {
      return Color(0xffbf1e2e);
    } else if (category == "Damaged") {
      return Colors.black;
    } else {
      int hash = category.hashCode;
      int red = (hash & 0xFF0000) >> 16;
      int green = (hash & 0x00FF00) >> 8;
      int blue = hash & 0x0000FF;
      return Color.fromARGB(255, red, green, blue);
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    await Provider.of<ComponentProvider>(context, listen: true)
        .addAction(widget.instanceCode, _selectedOption, "title", text);
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

    // Fetch actions only if it hasn't been fetched yet
    if (!hasFetchedActions) {
      componentProvider.getActions(widget.instanceCode);
      setState(() {
        hasFetchedActions = true; // Mark as fetched after calling
      });
    }

    // Trigger scroll to end after the widget is built
    if (componentProvider.itemActions.isNotEmpty && !scrolled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
        setState(() {
          scrolled = true; // Ensure we only scroll once
        });
      });
    }

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
          padding: const EdgeInsets.all(0), // Padding to give space from the left
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
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
        padding: const EdgeInsets.all(10.0),
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
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? const Color.fromARGB(
                                                255, 255, 255, 255)
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.2), // Shadow color
                                            blurRadius:
                                                6.0, // Spread of the shadow
                                            offset: Offset(
                                                0, 3), // Offset of the shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: isMe
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Chip(
                                            label: Text(
                                              action["action type"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                            backgroundColor: getCategoryColor(
                                                action["action type"]),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20), // Set the desired radius
                                            ),
                                            side: BorderSide.none,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 0), // Adjust padding
                                          ),
                                          if (action["action details"] != "")
                                            Text(
                                              action["action details"],
                                              style: TextStyle(fontSize: 16.0),
                                              softWrap:
                                                  true, // Ensures the text wraps within the container
                                              overflow: TextOverflow
                                                  .visible, // Prevent text from being cut off
                                            ),
                                          if (action["date"] != "")
                                            Padding(
                                              padding: EdgeInsets.only(left: 0),
                                              child: Text(
                                                action["date"],
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ),
                                          SizedBox(height: 4.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),

                      SizedBox(height: 4.0),
                      // Message Bubble
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
                      return DropdownMenuItem<String>(value: option, child: Text(option));
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
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextFormField(
                          controller: _messageController,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            hintText: "Message",
                            hintStyle: TextStyle(fontSize: 16.0),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.send, color: Colors.blue),
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
