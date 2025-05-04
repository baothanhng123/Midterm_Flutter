import 'package:flutter/material.dart';
import 'services/chat_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F4F3),
      ),
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final AIService _chatService = AIService();
  final String ipAddress = 'localhost'; //10.0.2.2(emulator) or localhost(windows)
  List<Map<String, String>> messages = [];
  String status = "Checking connection...";

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkMongoConnection();
    fetchMessagesFromBackend();
  }

  //CHECK backend connection
  void checkMongoConnection() async {
    try {
      final response =
          await http.get(Uri.parse("http://${ipAddress}:3000/messages"));
      if (response.statusCode == 200) {
        setState(() => status = "Welcome to chat GPT");
      } else {
        setState(() => status = "Backend error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => status = "Could not connect to chat service");
    }
  }

  Future<void> fetchMessagesFromBackend() async {
    try {
      final response =
          await http.get(Uri.parse("http://${ipAddress}:3000/messages"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          messages = data
              .map<Map<String, String>>((msg) => {
                    "role": msg["role"],
                    "text": msg["text"],
                  })
              .toList();
        });
      }
    } catch (e) {
      print("Exception fetching messages: $e");
    }
  }

  //send user input message to backend
  void _sendMessage() async {
    String userMessage = _textEditingController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": userMessage});
    });

    await http.post(
      Uri.parse("http://${ipAddress}:3000/messages"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "role": "user",
        "text": userMessage,
      }),
    );

    _textEditingController.clear();
    //node refocus after user type submit
    _focusNode.requestFocus();

    String botResponse = await _chatService.sendMessage(userMessage);

    setState(() {
      messages.add({"role": "bot", "text": botResponse});
    });

    await http.post(
      Uri.parse("http://${ipAddress}:3000/messages"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "role": "bot",
        "text": botResponse,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(status),
        backgroundColor: Color(0xFF2ECC71),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF2ECC71)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person, size: 40, color: Color(0xFF2ECC71)),
                  ),
                  SizedBox(width: 16),
                  Text('ChatGPT',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.explore),
              title: Text('Explore GPTs'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              //Delete CHAT
              title: Text('New Chat'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Start a new chat?"),
                      content: Text("This will clear the current messages."),
                      actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog only
                          },
                        ),
                        TextButton(
                          child: Text("Start new"),
                          onPressed: () async {
                            // Clear MongoDB messages via backend
                            await http.delete(
                                Uri.parse("http://${ipAddress}:3000/messages"));

                            setState(() {
                              messages.clear(); // Clear locally
                            });

                            Navigator.of(context).pop(); // Close dialog
                            Navigator.of(context).pop(); // Close drawer
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Chat History",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message["role"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: message["role"] == "user"
                          ? const Color(0xFF3498DB) // New color for user messages
                          : const Color(0xFFF1C40F), // New color for bot messages
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message["text"]!,
                        style: TextStyle(color: Colors.black)),
                  ),
                );
              },
            ),
          ),
          //USER input textfield
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE8ECEF),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                //send message button
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send, color: Color(0xFF2ECC71)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
