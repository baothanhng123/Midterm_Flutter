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
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        child: Card(
                            child: TextField(
                      //TEXT FIELD
                      controller: _controller,
                      decoration: InputDecoration(
                          hintText: "Ask anything",
                          enabledBorder: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 0.5),
                          )),
                      maxLines: null, // allow 4 lines
                      keyboardType:
                          TextInputType.multiline, //enable multiline input
                    ))),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
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
                )
              ],
            ))));
  }
}
