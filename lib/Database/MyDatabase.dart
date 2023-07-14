import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


const String DATABASENAME = "doctoDataBase.db"; // name of our database

const String USERSACCOUNTTABLENAME = "usersAccount";
const String PROFILETABLENAME = "Profile";
const String RAPPELTABLENAME = "Rappel";
const String VACCINTABLENAME = "vaccin";
const String MEDOCTABLENAME = "medoc";

const String COLUMNID = "id";



class MyDatabase {
  static Database? _database;


  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DATABASENAME);
    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          db.execute(
            "CREATE TABLE " + USERSACCOUNTTABLENAME
                + " (" + COLUMNID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                +
                " Mail TEXT, MDP TEXT);",
          );

          db.execute(
            "CREATE TABLE " + PROFILETABLENAME
                + " (" + COLUMNID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                +
                " id_account INTEGER, prenom TEXT, status TEXT, birthday TEXT, genre TEXT , poids INTEGER, taille INTEGER);",
          );

          db.execute(
            "CREATE TABLE " + RAPPELTABLENAME
                + " (" + COLUMNID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                +
                " id_profile INTEGER, status TEXT, date TEXT);",
          );

          db.execute(
            "CREATE TABLE " + VACCINTABLENAME
                + " (" + COLUMNID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                +
                " id_rappel TEXT, name TEXT);",
          );

          db.execute(
            "CREATE TABLE " + MEDOCTABLENAME
                + " (" + COLUMNID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                +
                " id_rappel INTEGER, name TEXT, posologie TEXT, grammage INTEGER, periode INTEGER);",
          );

        },
        onOpen: (db) {
          // Executed when the database is opened
          print('Database opened');
        }
    );
  }

  static Future<void> addElementAccountTable(String mail, String mdp) async {
    final db = await MyDatabase.database;

    await db.insert(USERSACCOUNTTABLENAME, {
      'Mail': mail,
      "MDP" : mdp
    });
    print("add Account");
  }


  static Future<bool> tryConnection(String email, String mdp, BuildContext context) async {
    final db = await MyDatabase.database;
    final mdpDataBase = await db.rawQuery(
      'SELECT MDP FROM ' + USERSACCOUNTTABLENAME + ' WHERE Mail = ?', [email],);
    if (mdpDataBase.length == 0)
      return false;
    return (mdpDataBase != null && mdpDataBase.first.values.first.toString() == mdp);
  }

  static Future<int> getId(String email) async {
    final db = await MyDatabase.database;
    final id = await db.rawQuery(
      'SELECT id FROM ' + USERSACCOUNTTABLENAME + ' WHERE Mail = ?', [email],);
    return int.parse(id.first.values.first.toString().toString());

  }


}