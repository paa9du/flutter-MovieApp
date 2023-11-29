import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  TextEditingController _textController = TextEditingController();
  double width = double.infinity;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        width: width,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _textController,
              textAlign: TextAlign.center,
              onTap: () {
                setState(() {
                  width = 280;
                });
              },
              onChanged: (text) {
                setState(() {
                  width = text.isEmpty ? double.infinity : 280;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 23,
                ),
                suffixIcon: _textController.text.isEmpty
                    ? null
                    : GestureDetector(
                        onTap: () {
                          _textController.clear();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.clear,
                            size: 23,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
