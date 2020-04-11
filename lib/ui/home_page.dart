import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart'


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=kWgZphvvX2CwAXqgnJTluwbIkWuZcKgS&limit=24&rating=G");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=kWgZphvvX2CwAXqgnJTluwbIkWuZcKgS&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "GIF Finder",
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ),
        elevation: 0.0,
        bottomOpacity: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(
                  right: 15, left: 15, top: 20, bottom: 20),
              height: 35,
              child: TextField(
                decoration: new InputDecoration(
                  prefixIcon: new Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.grey[790],
                  ),
                  fillColor: Colors.grey[300],
                  filled: true,
                  contentPadding: const EdgeInsets.all(5),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 0.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  )),
                  hintText: 'Procurar no giphy',
                ),
                onSubmitted: (text) {
                  setState(() {
                    _search = text;
                    _offset = 0;
                  });
                },
              )),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container(
                          child: Text(
                              "Erro ao carregar os dados, verifique sua conexão.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                        );
                      else
                        return _createGifTable(context, snapshot);
                  }
                }),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(15.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 15.0, mainAxisSpacing: 15.0),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length)
            return GestureDetector(
              child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.black, size: 70.0),
                    Text("Carregar mais...",
                        style: TextStyle(color: Colors.black, fontSize: 22.0)),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
        });
  }
}
