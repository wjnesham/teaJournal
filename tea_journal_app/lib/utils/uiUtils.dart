import 'package:flutter/material.dart';
import 'package:tea_journal_app/ui/teaListPage.dart';

import '../singleton.dart';

const double smallTextSize = 16.0;

List<Color> lightColors = [
  Colors.yellow[200],
  Colors.blueAccent[100],
  Colors.indigo[300],
];
List<Color> darkColors = [
  Colors.black,
  Colors.indigo,
  Colors.black,
];
List<Color> myColorArray = lightColors;

/// Add background color
Widget standardContainer(Widget contents) {
  return Container(
    decoration: BoxDecoration(
      // Box decoration takes a gradient
      gradient: LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        // Add one stop for each color. Stops should increase from 0 to 1
        stops: [0.1, 0.5, 0.9],
        colors: myColorArray,
      ),
    ),
    child: contents,
  );
}

Future<void> addNewTea (BuildContext context) async {
  await Singleton.instance.loadDatabase().then((val) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeaListPage(),
      )
  )
  );
}

Widget myAppBarWithShadowText(String title, {Widget rightButton: const Text('')}){
  return AppBar(
    backgroundColor: myColorArray[1],
    title: shadowText(title, 28.0),
    elevation: 8.0,
    iconTheme: new IconThemeData(
        color: myColorArray[0]
    ),
    actions: <Widget>[
      rightButton
    ],
  );
}

Future<void> showToast(GlobalKey<ScaffoldState> scaffoldKey, String msg) async {
  scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: shadowText(msg, smallTextSize),

        backgroundColor: myColorArray[1],
        duration: Duration(seconds: 3),
      ));
}

/// Returns text with a shadow.
Widget shadowText(String text, double fontSize){
  return Text(
    text,
    style: new TextStyle(
      fontSize: fontSize,
      color: myColorArray[0],
      shadows: <Shadow>[
        Shadow(
//          offset: Offset(1.0, 1.0),
          blurRadius: 2.0,
          color: Colors.black87,
        ),
      ],
    ),
  );
}

/// Custom TextField Widget
Widget getTextField(String label, TextEditingController control, bool hidden, TextInputType type, BuildContext context) {
  TextField field = TextField(textInputAction: TextInputAction.done,);
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
    child: Container(
      decoration: new BoxDecoration(
          color: Colors.black38,
          borderRadius: new BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: new TextField(
          textInputAction: field.textInputAction,
          keyboardType: type,
          style: new TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          controller: control,
          obscureText: hidden, // Obscure if true.
          decoration: new InputDecoration(
            labelStyle: new TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            labelText: label,
          ),
        ),
      ),
    ),
  );
}