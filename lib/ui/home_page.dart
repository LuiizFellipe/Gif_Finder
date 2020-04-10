import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=kWgZphvvX2CwAXqgnJTluwbIkWuZcKgS&limit=25&rating=G");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=kWgZphvvX2CwAXqgnJTluwbIkWuZcKgS&q=dog$_search&limit=25&offset=$_offset&rating=G&lang=en");
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("GIF Finder",
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold))),
        elevation: 0.0,
        bottomOpacity: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 22, left: 25, top: 20),
            height: 30,
            child: TextField(
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, size: 25, color: Colors.grey[790],),
              fillColor: Colors.grey[300],
              filled: true,
              contentPadding: const EdgeInsets.all(5),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: 'Search in giphy',
            )),
          )
        ],
      ),
    );
  }
}
