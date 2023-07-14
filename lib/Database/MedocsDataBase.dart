import 'package:doctolib/Database/MyDatabase.dart';

class MedocDataBase extends MyDatabase{


  static Future<int> addElementMedocsTable(String id_rappel, String name,  String posologie, int periode, int grammage) async {
    final db = await MyDatabase.database;

    int id = await db.insert(MEDOCTABLENAME, {
      'id_rappel': id_rappel,
      "name" : name,
      "posologie" : posologie,
      "grammage" : grammage,
      "periode" : periode

    });
    print("add Medocs");
    return id;
  }


  static Future<List<Map<String, Object?>>> getInfoMedoc(id_rappel) async{
    final db = await MyDatabase.database;
    var medoc = await db.rawQuery(
      'SELECT * FROM ' + MEDOCTABLENAME + ' WHERE id_rappel = ?', [id_rappel],);
    print(medoc);
    return medoc;
  }


  static void deleteElementMedoc(id_rappel) async{
    final db = await MyDatabase.database;

    await db.delete(
      MEDOCTABLENAME,
      where: 'id_rappel = ?',
      whereArgs: [id_rappel],
    );
  }


}