import 'package:doctolib/Database/MyDatabase.dart';

class VaccinDataBase extends MyDatabase{
  static Future<void> addElementVaccinTable(String id_rappel, String name) async {
    final db = await MyDatabase.database;

    await db.insert(VACCINTABLENAME, {
      'id_rappel': id_rappel,
      "name" : name

    });
    print("add Vaccin");
  }


  static Future<List<Map<String, Object?>>> getInfoVaccin(id_rappel) async{
    final db = await MyDatabase.database;
    var vaccin = await db.rawQuery(
      'SELECT * FROM ' + VACCINTABLENAME + ' WHERE id_rappel = ?', [id_rappel],);
    print(vaccin);
    return vaccin;
  }


  static void deleteElementVaccin(id_rappel) async{
    final db = await MyDatabase.database;

    await db.delete(
      VACCINTABLENAME,
      where: 'id_rappel = ?',
      whereArgs: [id_rappel],
    );
  }

}