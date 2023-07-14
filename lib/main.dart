import 'package:doctolib/Database/MyDatabase.dart';
import 'package:doctolib/Database/ProfileDataBase.dart';
import 'package:doctolib/Database/VaccinDataBase.dart';
import 'package:doctolib/utils/NavBar.dart';
import 'package:flutter/material.dart';

import 'Pages/Connexion/HomeConnexionPage.dart';

int id_account = 1;

void main() {
  runApp(HomeConnexionPage());
}

class MainPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    //MyDatabase.addElementAccountTable("admin@gmail.com", "m");
    //ProfileDataBase.addElementProfileTable(1, "31/05/2001", "admin", "H", "Parent", 73, 181);
    //ProfileDataBase.addElementProfileTable(1, "31/05/2001", "emma", "H", "Parent", 73, 181);

    //VaccinDataBase.addElementVaccinTable("1", "addManu");
    // RappelDataBase.clearTableRappel();

    return  MaterialApp(
      title: "Home",
      home: NavBar(1),
    );
  }
}