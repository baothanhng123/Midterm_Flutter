import 'package:flutter/material.dart';
import 'services/chat_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F4F3), // Nền xám nhạt
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
  List<Map<String, String>> messages = [];
  @override
  void dispose() {//cleaning up resources when a widget is removed 
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    String userMessage = _textEditingController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": userMessage});
    });

    _textEditingController.clear();
    _focusNode.requestFocus();

    String botResponse = await _chatService.sendMessage(userMessage);

    setState(() {
      messages.add({"role": "bot", "text": botResponse});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Deepseek"),
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
              decoration: BoxDecoration(
                color: Color(0xFF2ECC71),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'ChatGPT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.explore),
              title: Text('Explore GPTs'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add navigation or functionality for Explore GPTs here
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chats'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
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
                          ? const Color(
                              0xFF2ECC71) // Tin nhắn người dùng: xanh lá
                          : const Color(
                              0xFFD5F5E3), // Tin nhắn AI: xanh lá nhạt
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message["text"]!,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input field
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
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Icon(
                    Icons.send,
                    color: Color(0xFF2ECC71),
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
