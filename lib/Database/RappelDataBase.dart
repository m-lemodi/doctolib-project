import 'package:doctolib/Database/MedocsDataBase.dart';
import 'package:doctolib/Database/MyDatabase.dart';
import 'package:doctolib/Database/ProfileDataBase.dart';
import 'package:doctolib/Database/VaccinDataBase.dart';
import 'package:doctolib/utils/NotificationHelper.dart';

class RappelDataBase extends MyDatabase{



  static Future<int> addElementRappelTable(String id_profile, String status, String date) async {
    final db = await MyDatabase.database;

    final insertedId = await db.insert(RAPPELTABLENAME, {
      'id_profile': id_profile,
      "status" : status,
      "date" : date
    });
    print("add Rappel ID : "  + insertedId.toString());
    return insertedId;
  }


  static Future<List<Map<String, Object?>>> getAllRappelFromFamilly(idAccount) async{
    final db = await MyDatabase.database;
    var famille = await ProfileDataBase.getFamille(idAccount);
    var familleNameId = await ProfileDataBase.getFamilleIdName(famille);
    List<Map<String, Object?>> res = [];


    for (List<String> couple in familleNameId){
      List<Map<String, Object?>>  rappelByName = await db.rawQuery(
        'SELECT * FROM ' + RAPPELTABLENAME + ' WHERE id_profile = ?', [couple[1]],);
      List<Map<String, Object?>> rappelInfos = [];
      for (Map<String, Object?> rappel in rappelByName){
        String status = rappel["status"].toString();
        print(rappel["id"].toString());
        if (status == "vaccin")
        {
          Map<String, Object?> infoVaccin =
              (await VaccinDataBase.getInfoVaccin(rappel["id"]))[0];
          Map<String, Object?> mergedMap = {...rappel, ...infoVaccin};
          rappelInfos.add(mergedMap);
        }
        if (status == "medoc"){

          Map<String, Object?> infoMedoc =
          (await MedocDataBase.getInfoMedoc(rappel["id"]))[0];
          Map<String, Object?> mergedMap = {...rappel, ...infoMedoc};
          rappelInfos.add(mergedMap);

        }

      }

      Map<String, Object?> myMap = {
        "name"  : couple[0],
        "rappel" : rappelInfos,
      };
      print(myMap);
      res.add(myMap);
    }
    return res;
  }

  static getAllRappelFromName(List<Map<String, Object?>> list) {
    List<Map<String, Object?>> res = [];
    for (Map<String, Object?> profile in list){
      List<Map<String, Object?>> listRappel = profile["rappel"] as List<Map<String, Object?>>;
      for (Map<String, Object?> rappel in listRappel){
        res.add(rappel);
      }
    }
    print(res);
    return res;
  }

  static void clearTableRappel() async{
    final db = await MyDatabase.database;
    await db.delete(RAPPELTABLENAME);

    await db.delete(MEDOCTABLENAME) ;
    await db.delete(VACCINTABLENAME);
  }

  static void deleteElementRappel(id_rappel) async{
    final db = await MyDatabase.database;

    await db.delete(
      RAPPELTABLENAME,
      where: 'id = ?',
      whereArgs: [id_rappel],
    );
    NotificationHelper.cancelNotification(id_rappel);
  }


  static void deleteElementRappelWithLink(id_rappel, String status) async{
    if (status == "medoc")
      MedocDataBase.deleteElementMedoc(id_rappel);
    if (status == "vaccin")
      VaccinDataBase.deleteElementVaccin(id_rappel);
    deleteElementRappel(id_rappel);

  }


}