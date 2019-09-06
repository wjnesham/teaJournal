import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:tea_journal_app/utils/Tea.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

import '../singleton.dart';

//examples: https://github.com/jaguar-orm/sqflite

/// The adapter
SqfliteAdapter _teaAdapter;

///Name of the file/database holding scanned data - unit tests can change it as needed
///when adding or removing columns from the schema, need to increment filename by 1
String teaFileName = "/teaFile.json";

class TeaSqflite {

  TeaBean bean;

  init(String databaseFileName) async {
    if(_teaAdapter == null) {
      if(databaseFileName != null) {
        teaFileName = databaseFileName;
      }
      _teaAdapter = new SqfliteAdapter(await getDatabasesPath()+teaFileName, version: 1);
      //_adapter.
    }
    if(bean == null) {
      try {
        await _teaAdapter.connect();
      } catch(e) {
        print("Cannot connect to database");
        print(e.toString());
      }
      bean = new TeaBean();
    }
    await bean.createTable();
  }

  close() async {
    await _teaAdapter.close();
  }


  // Count items scanned.
  Future<int> countItemsScanned() async {
    if(bean == null) {
      await init(null);
    }
    int count = 0;
    List<Tea> dbTeaList = await bean.findAll();
    if(dbTeaList != null) {
      count = dbTeaList.length;
    }
    print('There are $count scanned into DB.');
    return count;
  }

}




class TeaBean {
  /// DSL Fields
  final StrField title = new StrField(Tea.titleName);
  final StrField description = new StrField(Tea.descriptionName);

  setTimeToIntField(int millisecondsSinceEpoch) {

  }

  /// Table name for the model this bean manages
  String get upcTableName => 'upc_table';

  /// Inserts a new record into table
  Future insert(Tea tea) async {

    final insert = Insert(upcTableName).setValues({
      Tea.titleName : tea.title,
      Tea.descriptionName: tea.description,
    });

    return await insert.exec(_teaAdapter); //_adapter.insert(inserter);
  }

  Future<Null> createTable() async {
    final upcTableEntry = new Create(upcTableName, ifNotExists: true);
    upcTableEntry.addStr(Tea.titleName, isNullable: true)
        .addStr(Tea.descriptionName, isNullable: true);

    await _teaAdapter.createTable(upcTableEntry);
  }

  /// Finds one post by [title]
  Future<Tea> findOne(String title) async {
    Find updater = new Find(upcTableName);
    updater.where(this.title.eq(title));
    Map upcMap = await _teaAdapter.findOne(updater);
    if(upcMap == null || upcMap.isEmpty) return null;

    Tea tea = getTeaDbFromMap(upcMap);
    return tea;
  }



  /// Finds all upc scans
  Future<List<Tea>> findAll() async {
    Find finder = new Find(upcTableName);

    List<Map> maps = (await _teaAdapter.find(finder)).toList();
    List<Tea> teaDbsList = new List<Tea>();

    for (Map map in maps) {
      teaDbsList.add(getTeaDbFromMap(map));
    }

    return teaDbsList;
  }

  ///When getting an object from the database using findOne() or findAll(),
  ///those methods return the objects in a Map.
  ///This method extracts the object from the Map and returns an instance of that type.
  Tea getTeaDbFromMap(Map upcMap) {
    Tea teaDb = new Tea();
    teaDb.title = upcMap[Tea.titleName];
    teaDb.description = upcMap[Tea.descriptionName] == null ? "" : upcMap[Tea.descriptionName];

    return teaDb;
  }

  /// Only updates the total
  Future<void> updateTotal(Tea teaDb, int totalAmt) async {

    Tea foundInList = Singleton.instance.foundTeaInList(teaDb.title);
    if(foundInList != null) {

      Update updater = new Update(upcTableName);
      updater.where(this.title.eq(foundInList.title));

      await _teaAdapter.update(updater);
    } else {
      print("updateTotal: Did not find tea in list");
    }
  }

  Future<void> updateUpcDbFields(Tea teaDb) async {
    if (teaDb == null) {
      print('Null upcDb passed in. UpcDb was not updated.');
      return;
    }
    bool foundInList = Singleton.instance.foundTeaInList(teaDb.title) != null;
    if(!foundInList) {
      print('Upc not found: UpcDb was not updated.');
      return;
    }

    Update updater = new Update(upcTableName);
    if (updater.where(this.title.eq(teaDb.title)) != null) {
      updater.where(this.title.eq(teaDb.title));

      updater.set(this.title, teaDb.title);
      updater.set(this.description, teaDb.description);

      await _teaAdapter.update(updater);
    } else {
      print('Upc matched null: UpcDb was not updated.');
    }
  }

  // Removes one by upc code.
  Future<void> removeOne(String title) async {
    Remove deleter = new Remove(upcTableName);
    deleter.where(this.title.eq(title));
    return await _teaAdapter.remove(deleter);
  }

  Future<int> removeAll() async {
    Remove deleter = new Remove(upcTableName);
    return await _teaAdapter.remove(deleter);
  }

  Future<void> loadUpcEntries() async {
    Singleton.instance.teaList = await findAll();
  }


  ///return false if found in database - that is, not added to database because found
  ///may want to add exception handler if db fails
  Future<void> addUpcToDevice(Tea teaDb, String goodImageUrl) async {

    Tea foundTea = await findOne(teaDb.title);
    if(foundTea != null && foundTea.title == teaDb.title) {
      return;
    }

    if (teaDb.title == null || teaDb.title.isEmpty) {
      print ('Failed to add upcDb to device.');
      return;
    }
    Singleton.instance.teaList.add(teaDb);
    await insert(teaDb);
    print ('Added upcDb to device.');
    //added upc
  }

  // Call this and setState inside then
  Future<void> loadDatabaseToSingletonList() async {
    List<Tea>dbTeaList = await findAll();
    if (Singleton.instance.teaList.isNotEmpty) {
      Singleton.instance.teaList.clear();
    }
    Singleton.instance.teaList.addAll(dbTeaList);
  }

}
