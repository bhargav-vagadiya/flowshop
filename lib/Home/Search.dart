import 'package:flowshop/Constants/Constant.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: search,
            autofocus: true,
            showCursor: true,
            cursorColor: Colors.black,
            onChanged: (value){
            setState(() {

            });
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
                focusColor: Colors.black,
                hoverColor: Colors.black,
                fillColor: Colors.black,
                hintText: "Search")),
        elevation: 1,
        actions: [if(search.text.isNotEmpty) IconButton(onPressed: () {setState(() {
          search.clear();
        });}, icon: Icon(Icons.close))],
      ),
      backgroundColor: bgcolor,
    );
  }
}
