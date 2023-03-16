import 'dart:io';

import 'package:flutter/services.dart';
import 'package:my_database_app/model/city_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'student.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "student.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data =
          await rootBundle.load(join('assets/database', 'student.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }

  Future<List<Map<String, Object?>>> getStudents() async {
    Database database = await initDatabase();
    return await database.rawQuery(
        'SELECT * from StudentMaster s INNER JOIN CityMaster c on s.CityID = c.CityID');
  }

  Future<int> delete(id) async {
    Database database = await initDatabase();
    return await database
        .delete('StudentMaster', where: 'StudentID = ?', whereArgs: [id]);
  }

  Future<int> insert(map) async {
    Database database = await initDatabase();
    return await database.insert('StudentMaster', map);
  }

  Future<int> update(map, id) async {
    Database database = await initDatabase();
    return await database
        .update('StudentMaster', map, where: 'StudentID = ?', whereArgs: [id]);
  }

  Future<List<CityModel>> getCities() async {
    Database database = await initDatabase();
    final data = await database.rawQuery('SELECT CityID,CityName FROM CityMaster');
    List<CityModel> cityList = [];
    for(var e in data){
      CityModel cityModel = CityModel();
      cityModel.CityID = int.parse(e['CityID'].toString());
      cityModel.CityName = e['CityName'].toString();
      cityList.add(cityModel);
    }
    return cityList;
  }
}
