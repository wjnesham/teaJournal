import 'package:flutter/material.dart';
import 'package:tea_journal_app/utils/uiUtils.dart';

class LoginPage extends StatefulWidget {
  /// Await?
//  final UserStorage storage;
//  LoginPage({Key key, @required this.storage}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final teaTextController = TextEditingController();
  final descriptionController = TextEditingController();


  @override
  void dispose() {
    //Clean up the controller when the Widget is disposed
    super.dispose();
  }

  Future<void> loadUserFromFile() async {
//    PersistenceHelper userHelper = new PersistenceHelper();

//    teaTextController.text = _currentUser.email;
//    descriptionController.text = _currentUser.password;
  }

  @override
  void initState() {
    super.initState();
    loadUserFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: standardContainer(
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  getTextField('Tea', teaTextController, false, TextInputType.emailAddress, context),
                  new SizedBox(height: 10.0,),
                  getTextField('Description', descriptionController, true, TextInputType.text, context),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  } // end build



//  // Store tea on device.
//  Future<void> rememberUser(String email, String pass) async {
//    try {
//      PersistenceHelper userHelper = new PersistenceHelper();
//      await userHelper.storeUser(email, pass);
//    } catch (e) {
//      // If encountering an error, return 0.
//      print('Failed to store user? Exception: ' + e.toString());
//      return;
//    }
//  }




} // End of class.