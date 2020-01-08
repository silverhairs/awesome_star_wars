import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import './constants.dart';
import './character_details.dart';
import './saved_characters.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFFEB1555),
      ),
      home: Homepage(),
      routes: <String, WidgetBuilder>{
        '/details': (BuildContext context) => CharacterDetails(),
        '/saved': (BuildContext context) => SavedCharacter(),
      },
    ),
  );
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List data = [];
  Future<String> getData() async {
    http.Response response = await http.get(
      Uri.encodeFull('https://awesome-star-wars-api.herokuapp.com/characters'),
      headers: {'Accept': 'application/json'},
    );
    Map jsonFormat = jsonDecode(response.body);
    setState(() {
      data = jsonFormat['data'];
    });
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AWESOME STAR WARS'),
        backgroundColor: Color(0xFFEB1555),
      ),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (ctx, index) {
          return FlatButton(
            child: Card(
              color: Color(0xFF111328),
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          foregroundColor: Color(0xFFEB1555),
                          radius: 40,
                          backgroundImage: NetworkImage(data[index]['image']),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          '${data[index]['name']}'.toUpperCase(),
                          style: GoogleFonts.sourceCodePro(
                            textStyle: kLabelTextStyle,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/details');
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.folder_special),
        onPressed: () {
          Navigator.of(context).pushNamed('/saved');
        },
      ),
    );
  }
}
