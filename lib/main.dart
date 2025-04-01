import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Chat GPT"),
          centerTitle: true,
        ),
        body: _body(), //body
      ),
    );
  }
}

//class for body
class _body extends StatefulWidget {
  @override
  State<_body> createState() => _bodyState();
}

class _bodyState extends State<_body> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
            padding: EdgeInsets.all(8),
            child: IntrinsicHeight(
                child: Column(
              children: [
                Expanded(
                    child: Container(
                  child: Text(
                    "What can I help you with",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                )),
                Row(
                  children: [
                    // Icon(Icons.photo_size_select_actual_rounded),
                    Expanded(
                        child: Container(
                          height: 150,
                          //TEXT FIELD
                            child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                          hintText: "Ask anything",
                          enabledBorder: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.zero)
                          )),
                      
                      maxLines: null,
                      //allows users to press "Enter" to move to the next line inside a TextField
                      textInputAction: TextInputAction.newline,   
                      keyboardType: TextInputType.multiline,
                      expands: false,
                    ))),
                    SizedBox(
                      height: 50,
                      //Button
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },

                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[50],
                            
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)))),
                        child: Icon(
                          Icons.arrow_forward,
                        ),
                      ),
                    ),
                   
                  ],
                ),
                
              ],
            ))));
  }
}
