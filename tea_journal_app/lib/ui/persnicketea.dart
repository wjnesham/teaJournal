import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tea_journal_app/utils/uiUtils.dart';

class PersnicketeaPage extends StatefulWidget {

  @override
  _PersnicketeaPageState createState() => _PersnicketeaPageState();
}

class _PersnicketeaPageState extends State<PersnicketeaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> executeAfterBuild() async {
    String welcomeMsg = 'Welcome to Molly\'s Tea App!';

    showToast(_scaffoldKey, welcomeMsg);
  }

  @override
  void initState() {
    super.initState();
//    loadTeaListFromFile();
    Future.delayed(Duration(milliseconds: 0)).then(
            (_) => executeAfterBuild()
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: myAppBarWithShadowText("Tea List"),
//      AppBar(
//        title: Text("Tea List"),
//      ),
        body: standardContainer(
        Text("Persnicketea.com"),
    ),
//    floatingActionButton: FloatingActionButton(
//    onPressed: () {
//    addTeaToList(teaTextController.text, descriptionController.text);
//    },
//    tooltip: 'Add a new tea',
//    child: Icon(Icons.add),
//    ),
    );
  }
}