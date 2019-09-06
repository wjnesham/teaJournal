import 'control/tea_storage.dart';
import 'utils/Tea.dart';

class Singleton {
  static final Singleton _singleton = new Singleton._internal();


  Singleton._internal();

  static Singleton get instance => _singleton;

  TeaSqflite teaSqflite = new TeaSqflite();

  //Upc upc;
  Tea currentTea;
  List<Tea> teaList = new List<Tea>();


  bool isValidUpcDbEntriesIndex(int index) {
    if(teaList == null || teaList.length == 0 ||
        index >= teaList.length || teaList[index] == null) {
      return false;
    }
    return true;
  }

  ///if found, update total and return true
  Tea foundTeaInList(String teaTitle) {
    for(Tea tea in teaList) {
      if(teaTitle == tea.title) {
        return tea;
      }
    }
    return null;
  }

  Future<void> loadDatabase() async {

    await teaSqflite.init(null);
    await teaSqflite.bean.loadDatabaseToSingletonList();
    return;
  }

}