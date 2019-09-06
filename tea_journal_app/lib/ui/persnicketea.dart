import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class PersnicketeaPage extends StatefulWidget {
  @override
  _PersnicketeaPageState createState() => _PersnicketeaPageState();
}

class _PersnicketeaPageState extends State<PersnicketeaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new WebviewScaffold(
      key: _scaffoldKey,
      url: "https://persnicketea.com",
      appBar: new AppBar(
        title: new Text("Molly\'s Tea Shop"),
      ),
    );
  }
}