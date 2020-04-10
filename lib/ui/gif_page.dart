import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class gifPage extends StatelessWidget {
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
    );
  }
}