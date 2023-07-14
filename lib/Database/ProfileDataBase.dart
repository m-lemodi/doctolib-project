import 'package:doctolib/Database/MyDatabase.dart';

class ProfileDataBase extends MyDatabase{

  static Future<void> addElementProfileTable(int idAccount, String birth, String prenom, String genre,String status, int poids, int taille) async {
    final db = await MyDatabase.database;

    await db.insert(PROFILETABLENAME, {
      'id_account': idAccount,
      "prenom": prenom,
      "genre": genre,
      "status": status,
      "birthday" : birth,
      "poids" : poids,
      "taille" : taille
    });
    print("add Profile");
  }

  static Future<List<Map<String, Object?>>> getFamille(idAccount) async{
    final db = await MyDatabase.database;
    final famille = await db.rawQuery(
      'SELECT * FROM ' + PROFILETABLENAME + ' WHERE id_account = ?', [idAccount],);
    return famille;
  }


  static List<String> getFamilleName(  List<Map<String, Object?>>famille ) {
    List<String> res = [];
    for (var  profile in famille){
      String prenom = profile['prenom'] as String;
      res.add(prenom);
    }
    return res;
  }

  static List<List<String>> getFamilleIdName(  List<Map<String, Object?>>famille ) {
    List<List<String>> res = [];
    for (var  profile in famille){
      String prenom = profile['prenom'] as String;
      String id = getFamilleNameID(famille, prenom).toString();
      res.add([prenom, id]);
    }
    return res;
  }



  static int getFamilleNameID(  List<Map<String, Object?>>famille , name) {
    for (var  profile in famille){
      String prenom = profile['prenom'] as String;
      if (name == prenom)
        return profile['id'] as int;
    }
    return -1;
  }


  static Future<String> getNameProfileFromaRappel(int id_profile) async{
    final db = await MyDatabase.database;
    final name = await db.rawQuery(
      'SELECT Name FROM ' + PROFILETABLENAME + ' WHERE id = ?', [id_profile],);
    return name.first.values.toString();
  }

}