import 'package:flutter/material.dart';
import 'package:tea_journal_app/ui/persnicketea.dart';
import 'package:tea_journal_app/utils/Tea.dart';
import 'package:tea_journal_app/utils/persistence_helper.dart';
import 'package:tea_journal_app/utils/uiUtils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tea_journal_app/control/tea_storage.dart' as dbController;

import '../singleton.dart';

class TeaListPage extends StatefulWidget {

  @override
  _TeaListPageState createState() => _TeaListPageState();
}

class _TeaListPageState extends State<TeaListPage> {
  dbController.TeaSqflite teaSqflite = Singleton.instance.teaSqflite;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final teaTextController = TextEditingController();
  final descriptionController = TextEditingController();


  @override
  void dispose() {
    //Clean up the controller when the Widget is disposed
    super.dispose();
  }

//  Future<void> loadTeaListFromFile() async {
//    PersistenceHelper teaHelper = new PersistenceHelper();
//
//  }

  Future<void> executeAfterBuild() async {
    String welcomeMsg = 'Welcome to Molly\'s Tea App!';

    if (Singleton.instance.teaList == null) {
      Singleton.instance.teaList = new List<Tea>();
    }

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
      appBar: myAppBarWithShadowText("Tea List", rightButton: persnicketeaButton(context)),
//      AppBar(
//        title: Text("Tea List"),
//      ),
      body: standardContainer(
//                  Column(
//                    children: <Widget>[

                      NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverOverlapAbsorber(
                              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                              child: SliverAppBar(
                                title: const Text('Enter New Tea Here'), // This is the title in the app bar.
                                pinned: true,
                                expandedHeight: 150.0,
                                forceElevated: innerBoxIsScrolled,
                                bottom: TabBar(
                                  // These are the widgets to put in each tab in the tab bar.
                                  tabs: Singleton.instance.teaList.map((Tea tea) => Tab(text: tea.title)).toList(),
                                ),
                              ),
                            ),
                          ];
                        },
                        body: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getTextField('Tea', teaTextController, false, TextInputType.emailAddress, context),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                              child: getTextField('Description', descriptionController, false, TextInputType.text, context),
                            ),
                          ],
                        ),
                      ),


//                      Expanded(
//                        child: ListView.separated(
//                          padding: const EdgeInsets.all(8.0),
//
//                          itemCount: Singleton.instance.teaList.length,
//                          itemBuilder: (BuildContext context, int index) {
//                            return GestureDetector(
//                              child: Slidable(
//                                actionPane: SlidableDrawerActionPane(),
//                                actionExtentRatio: 0.25,
//                                child: Container(
//                                  decoration: new BoxDecoration(
//                                    color: Colors.white,
//                                    borderRadius: new BorderRadius.all(
//                                        const Radius.circular(20.0)
//                                    ),
//                                  ),
//                                  child: Container(
//                                      child: Column(
//                                        children: <Widget>[
//                                          Padding(
//                                            padding: const EdgeInsets.all(8.0),
//                                            child: Text(Singleton.instance.teaList[index].title),
//                                          ),
//                                          Padding(
//                                            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
//                                            child: Text(Singleton.instance.teaList[index].description),
//                                          ),
//                                        ],
//                                      ),
//
//                                  ),
//                                ),
//                                actions: <Widget>[
//                                  Container(
//                                    child: IconSlideAction(
//                                      color: Colors.redAccent,
//                                      icon: Icons.delete_forever,
//                                      onTap: () {
//                                        if(Singleton.instance.isValidUpcDbEntriesIndex(index)) {
//
//                                          showToast(_scaffoldKey, 'Deleted item.');
//                                        } else {
//                                          print("Invalid index = $index");
//                                        }
//                                      },
//                                    ),
//                                  ),
//                                ],
//                                secondaryActions: <Widget>[
//                                  // Swipe the other way...
//                                ],
//                              ),
//
//                              onTap: (){
//                                // onTap for teaList[index]
//                                print(Singleton.instance.teaList[index].title);
//                                setState(() {
//                                  teaTextController.text = Singleton.instance.teaList[index].title;
//                                  descriptionController.text = Singleton.instance.teaList[index].description;
//                                });
//
//                              },
//                            );
//                          },
//                          separatorBuilder: (BuildContext context, int index) => const Divider(
//                            height: 8.0,
//                          ),
//                        ),
//                      ),

//                    ],
//                  ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (Singleton.instance.teaList == null) {
            Singleton.instance.teaList = new List<Tea>();
          }
          addTeaToList(teaTextController.text, descriptionController.text);
        },
        tooltip: 'Add a new tea',
        child: Icon(Icons.add),
      ),
    );
  } // end build

  Future<void> goToPersnicketea (BuildContext context) async {
    await Singleton.instance.loadDatabase().then((val) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersnicketeaPage(),
        )
    ));
  }

  Widget persnicketeaButton (BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Go to webView
        goToPersnicketea(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: new BoxDecoration(
              color: myColorArray[2],
              borderRadius: new BorderRadius.circular(18.0)),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.store_mall_directory, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Store",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTeaToList (String title, String description) async {
    Tea newTea = Tea(title: title, description: description);

    if (await teaSqflite.bean.findOne(title) != null) {
      teaSqflite.bean.removeOne(title).then((_) => setState(() {
        Singleton.instance.teaList.removeWhere((tea) => tea.title == title);
        teaSqflite.bean.addUpcToDevice(newTea, "");
      }));
    } else {
      setState(() {
        teaSqflite.bean.addUpcToDevice(newTea, "");
      });
    }

    setState(() {
      teaTextController.text = "";
      descriptionController.text = "";
    });
  }

  Future<void> deleteTea (Tea tea) async {
    setState(() {
      if (tea != null) {
        teaSqflite.bean.removeOne(tea.title);
      }
    });
  }




}

class PersnicketeaPagePage {
} // End of class.