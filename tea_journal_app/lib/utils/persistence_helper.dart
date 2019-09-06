import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core' as prefix0;
import 'dart:io';

//import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:path_provider/path_provider.dart';

bool rememberMe = true; // Default value
const int TWO_BILLION = 2000000000;

/// See unit test persistence_helper_test.dart
class PersistenceHelper {

  static const String stateFileName = "/appstateNew.json";
  static const String upcFileName = "/upcStorage.json";
  static const String userFileName = "/rememberMe.txt"; //Needs '/'
  static const String emailString = "email";
  static const String passwordString = "password";

  Future<List<String>> load() async {
    List<dynamic> teasPurchased;
    String dataDir = await _getDirectory();
    File file = new File(dataDir + stateFileName);
    if (file.existsSync()) {
      String json = file.readAsStringSync();
      JsonDecoder decoder = new JsonDecoder();
      Map data = decoder.convert(json);
      teasPurchased = data['teas'];
    }

    return teasPurchased.cast<String>().toList();
  }

  Future store(List<String> dataList) async {
    String dataDir = await _getDirectory();
    File file = new File(dataDir + stateFileName);
    Map data = {
      'teas': dataList
    };
    JsonEncoder encoder = new JsonEncoder();
    String json = encoder.convert(data);
    file.writeAsStringSync(json);
  }

  Future<Map<String, dynamic>> loadMap(String fileName) async {
    Map<String, dynamic> data;
    String dataDir = await _getDirectory();
    File file = new File(dataDir + fileName);
    if (file.existsSync()) {
      String json = file.readAsStringSync();
      JsonDecoder decoder = new JsonDecoder();
      data = await decoder.convert(json);
    }
    return data;
  }

  // Dynamics?
  Future storeMap(Map<String, dynamic> data, String fileName) async {
    String dataDir = await _getDirectory();
    File file = new File(dataDir + fileName);

    JsonEncoder encoder = new JsonEncoder();
    String json = encoder.convert(data);
    file.writeAsStringSync(json);
  }


  // Returns directory path.
  Future<String> _getDirectory() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    new Directory(appDocDirectory.path).create(recursive: true)
    // The created directory is returned as a Future.
        .then((Directory directory) {
      appDocDirectory = directory;
    });

    return appDocDirectory.path;
  }

}