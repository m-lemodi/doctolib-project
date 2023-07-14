import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:doctolib/Database/RappelDataBase.dart';
import 'package:doctolib/Database/VaccinDataBase.dart';
import 'package:doctolib/utils/NavBar.dart';
import 'package:doctolib/utils/NotificationHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../Database/MedocsDataBase.dart';
import '../Database/ProfileDataBase.dart';
import '../main.dart';
import '../utils/style.dart';
import '../utils/utilsFct.dart';
String? selectedProfile2 = "All";
String sort = "All";

class Rappel extends StatefulWidget{
  @override
  State<Rappel> createState() => _Rappel();
  }

class _Rappel extends State<Rappel>{

  @override
  Widget build(BuildContext context) {
    final Future<List<Map<String, Object?>>> famille =  ProfileDataBase.getFamille(id_account);


            return Scaffold(
                body:
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        // child : SingleChildScrollView(
                        child:
                        Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  // Ajouter un Spacer pour pousser le IconButton tout à droite

                                  Text("Nos Rappels", style: TitleStyle,),
                                  Spacer(),
                                  // Ajouter un Spacer pour pousser le IconButton tout à droite

                                  IconButton(onPressed: () {
                                    print("del Rappel");
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                AddRappel()));
                                  },
                                      icon: Container(
                                        decoration: iconButton,
                                        child: Center(
                                          child: Icon(
                                              Icons.add, color: Colors.white),
                                        ),
                                      )
                                  ),
                                  IconButton(onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Connexion Doctolib',
                                              style: TextStyle(
                                                  color: Colors.green),),
                                            content: Column(

                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    "Entrer vos identifiant afin d'importer vos rappels Doctolib"),
                                                SizedBox(height: 10.0,),

                                                TextField(
                                                    decoration: InputDecoration(
                                                      hintText: 'Saisir mail doctolib',
                                                      border: OutlineInputBorder(),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .green), // Définir la couleur du contour en vert
                                                      ),

                                                    )),
                                                SizedBox(height: 16.0,),
                                                TextField(
                                                    decoration: InputDecoration(
                                                      hintText: 'Saisir mdp doctolib',
                                                      border: OutlineInputBorder(),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .green), // Définir la couleur du contour en vert
                                                      ),

                                                    ))
                                              ],),
                                            actions: [
                                              TextButton(
                                                child: Text('Link'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }, icon: Container(
                                    decoration: iconButton,
                                    child: Center(
                                      child: Icon(Icons.connect_without_contact,
                                          color: Colors.white),
                                    ),
                                  )

                                  )
                                ]
                            ),
                            CustomRadioButton(
                              selectedBorderColor: Colors.green,
                              unSelectedBorderColor: Colors.green,

                              elevation: 0,
                              absoluteZeroSpacing: false,
                              unSelectedColor: Theme
                                  .of(context)
                                  .canvasColor,
                              buttonLables: [
                                'Tous',
                                'Vaccins',
                                'Medocs',
                              ],
                              buttonValues: [
                                "All",
                                "vaccin",
                                "medoc",
                              ],
                              buttonTextStyle: ButtonTextStyle(

                                  selectedColor: Colors.white,
                                  unSelectedColor: Colors.black,
                                  textStyle: TextStyle(fontSize: 16)),
                              radioButtonValue: (value) {
                                setState(() {
                                  // Generate new data or update existing data
                                  sort = value;
                                });

                                print(value);
                              },
                              selectedColor: Colors.green,
                            ),
                            SizedBox(height: 16.0),

                            FutureBuilder<List<Map<String, Object?>>>(
                            future: famille,
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot)
                              {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                              return Text('Erreur: ${snapshot.error}');
                              } else {

                                List<Map<String, Object?>> famille = snapshot.data!;
                                List<String> choices =["All", ...ProfileDataBase.getFamilleName(famille)];
                                return DropdownButtonFormField(
                                value: selectedProfile2,
                                items: choices.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedProfile2 = newValue!;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'filtre sujet',
                                  border: OutlineInputBorder(),

                                )
                            ); }}),
                            SizedBox(height: 16.0),
                            Expanded(

                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: MediaQuery
                                            .of(context)
                                            .size
                                            .height),
                                    child:
                                    RappelContainer()
                                )

                            )
                          ],
                        )
                      //)
                    )

            );



  }
}

class AddRappel extends StatefulWidget{
  @override
  State<AddRappel> createState() => _AddRappel();

}

late MyDateField _date;

class _AddRappel extends State<AddRappel>{

  IconData? selectedIcon = null;
  bool showTextMedoc = false;
  bool showTextVaccin= false;

  IconData vac = Icons.vaccines_outlined;
  IconData medoc = Icons.healing;

  TextEditingController _nameVaccin = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _nameMedoc = TextEditingController();
  TextEditingController _posologie = TextEditingController();
  TextEditingController _grammage = TextEditingController();
  TextEditingController _periode = TextEditingController();


  void _onIconSelected(IconData? icon) {
    setState(() {
      selectedIcon = icon;
      showTextVaccin = icon == vac;
      showTextMedoc =  icon == medoc;
      print(showTextVaccin);
      print(showTextMedoc);
      if (!showTextVaccin) {
        _nameVaccin.clear();
      }
    });
  }
  String? selectedProfile;
  final Future<List<Map<String, Object?>>> famille =  ProfileDataBase.getFamille(id_account);
  @override
  Widget build(BuildContext context){
      return FutureBuilder<List<Map<String, Object?>>>(
          future: famille,
          builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot)
      {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          List<Map<String, Object?>> famille = snapshot.data!;
          List<String> choices = ProfileDataBase.getFamilleName(famille);
          return Scaffold(
            appBar: AppBar(
              title: Text('Ajouter un Rappel'),
              backgroundColor: Colors.green,
            ),
            body: Column(
              children: [
                SizedBox(height: 30.0),
            DateTimeField(
              decoration: const InputDecoration(
                hintText: 'Saisir la date',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green), // Définir la couleur du contour en vert
                ),
              ),
              format: DateFormat("dd/MM/yyyy"),
              controller: _date,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2200),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.green, // header background color
                          onPrimary: Colors.white, // header text color
                          onSurface: Colors.black, // body text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green, // button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                return date;
              },
            ),
                SizedBox(height: 8.0),

                DropdownButtonFormField(
                    value: selectedProfile,
                    items: choices.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProfile = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Saisir le sujet',
                      border: OutlineInputBorder(),

                    )
                ),
                SizedBox(height: 30.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(vac),
                        Radio(
                          value: vac,
                          groupValue: selectedIcon,
                          onChanged: _onIconSelected,
                          fillColor: MaterialStateColor.resolveWith((states) => Colors.green),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(medoc),

                        Radio(
                          value: medoc,
                          groupValue: selectedIcon,
                          onChanged: _onIconSelected,
                          fillColor: MaterialStateColor.resolveWith((states) => Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: showTextVaccin,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _nameVaccin,
                      decoration: InputDecoration(
                        hintText: 'Nom du vaccin ',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green), // Définir la couleur du contour en vert
                        ),

                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: showTextMedoc,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _nameMedoc,
                      decoration: InputDecoration(
                        hintText: 'Nom du medédicament ',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green), // Définir la couleur du contour en vert
                        ),

                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: showTextMedoc,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _posologie,
                      decoration: InputDecoration(
                        hintText: 'posologie du medédicament par jour',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green), // Définir la couleur du contour en vert
                        ),

                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: showTextMedoc,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _periode,
                      decoration: InputDecoration(
                        hintText: 'nombre de jour de prise',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green), // Définir la couleur du contour en vert
                        ),

                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: showTextMedoc,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _grammage,
                      decoration: InputDecoration(
                        hintText: 'grammage du médicament en g',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green), // Définir la couleur du contour en vert
                        ),

                      ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () async {
                  await NotificationHelper.init();
                  DateFormat format = DateFormat("dd/MM/yyyy");
                  String date = _date.text;
                  DateTime parsedDateTime = format.parse(date);
                  tz.TZDateTime scheduledDate = tz.TZDateTime(
                      tz.local,
                      parsedDateTime.year,
                      parsedDateTime.month,
                      parsedDateTime.day,
                      8); // 8h


                  int id_profile = ProfileDataBase.getFamilleNameID(famille, selectedProfile);
                  print(id_profile.toString() + " " + date + " " +
                      _nameVaccin.text);
                  if (showTextVaccin) {
                    int id_rappel = await RappelDataBase.addElementRappelTable(
                        id_profile.toString(), 'vaccin', date);
                    VaccinDataBase.addElementVaccinTable(
                        id_rappel.toString(), _nameVaccin.text);
                    NotificationHelper.showScheduledNotification(title: "Don't forget ! ⏱️", body: "You have a vaccine coming up 💉", uuid: id_rappel, scheduledDate: scheduledDate);
                  }
                  if (showTextMedoc) {
                    int id_rappel = await RappelDataBase.addElementRappelTable(
                        id_profile.toString(), 'medoc', date);
                    MedocDataBase.addElementMedocsTable(
                       id_rappel.toString(), _nameMedoc.text, _posologie.text, int.parse(_periode.text), int.parse(_grammage.text));
                    NotificationHelper.showScheduledNotification(title: "Don't forget ! ⏱️", body: "You need to take your meds 💊", uuid: id_rappel, scheduledDate: scheduledDate);
                  }
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => NavBar(1)));
                }, child: Text("Ajouter rappel"),
                    style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16.0),
                    backgroundColor: Colors.green, // Définir la couleur du bouton en vert
                  )
                ),
              ],
            ),
          );
        }
      }
      );
  }
}

class RappelContainer extends StatefulWidget{
  @override
  State<RappelContainer> createState() => _RappelContainer();
}
class _RappelContainer extends State<RappelContainer>{

  void _showPopup(BuildContext context, Map<String, Object?> rappel, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rappel pour ${name}'),
          content: TextPopUp(rappel),
          actions: [
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Column TextPopUp( Map<String, Object?> rappel){
    if (rappel["status"] == "medoc")
      return Column(
        mainAxisAlignment:  MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
        Text("posologie : " + rappel["posologie"].toString()),
        SizedBox(height: 8.0,),
        Text("grammage : " + rappel["grammage"].toString()),
        SizedBox(height: 8.0,),

        Text("médicament : " + rappel["name"].toString()),
        SizedBox(height: 8.0,),

        Text("effet secondaire : la mort"),
      ],);
    return Column(
        mainAxisAlignment:  MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
      Text("N'oubliez pas votre vaccin")
        ]);
  }

  static List<Map<String, Object?>> sortByStatus(List<Map<String, Object?>> rappelNS) {
    List<Map<String, Object?>> res = [];
    print(sort);
    if (sort == "All")
      return rappelNS;
    for (var el in rappelNS){
      if (el["status"].toString() == sort)
        res.add(el);
    }
    return res;
  }

  static List<Map<String, Object?>> sortByProfile(List<Map<String, Object?>> f, List<Map<String, Object?>> rappelNS) {
    List<Map<String, Object?>> res = [];
    if (selectedProfile2 == "All")
      return rappelNS;
    for (var el in rappelNS){
      String name = getNameRappel(f, el);
      print(name);
      if (name == selectedProfile2)
        res.add(el);
    }
    return res;
  }

  Future<List<Map<String, Object?>>> rappel = RappelDataBase.getAllRappelFromFamilly(id_account);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: rappel,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Erreur: ${snapshot.error}');
          } else {
            List<Map<String, Object?>> rappelByName = snapshot.data!;
            List<Map<String, Object?>> rappelNS = sortByDate( RappelDataBase.getAllRappelFromName(rappelByName));
            List<Map<String, Object?>> rappel =  sortByProfile(rappelByName, sortByStatus(rappelNS));
            return Container(
                child:
                ListView.builder(
                    itemCount: rappel.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                          children: [
                            SizedBox(height: 10.0),
                            Container(
                                decoration: box,
                                height: 80.0,
                                child: Row(
                                    children: [
                                      Icon(goodIcon((rappel[index]["status"]).toString())),
                                      Spacer(), // Ajouter un Spacer pour pousser le IconButton tout à droite

                                      Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,

                                          children: [
                                            Text(getNameRappel(rappelByName, rappel[index])),
                                            Text(getNameProduit(rappel[index])),
                                          ]

                                      ),
                                      Spacer(), // Ajouter un Spacer pour pousser le IconButton tout à droite

                                      Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,

                                          children: [
                                            Text(rappel[index]["date"].toString()),
                                            Text(getDateEnd(rappel[index])),
                                          ]
                                      ),
                                      Spacer(), // Ajouter un Spacer pour pousser le IconButton tout à droite
                                      IconButton(onPressed: () {
                                        print("pop up");
                                        _showPopup(context, rappel[index], getNameRappel(rappelByName, rappel[index]));
                                      },
                                          icon: Icon(Icons.remove_red_eye,
                                            color: Colors.green,)),


                                      IconButton(onPressed: (){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Suppression rappel', style: TextStyle(color:  Colors.green),),
                                                content: Column(

                                                  mainAxisAlignment:  MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text("Etes vous sur de vouloir supprimer ce rappel"),

                                                  ],),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Supprimer'),
                                                    onPressed: () {
                                                      RappelDataBase.deleteElementRappelWithLink(rappel[index]["id_rappel"].toString(),rappel[index]["status"].toString() );
                                                      Navigator.of(context).pop();
                                                      Navigator.push(context,  PageRouteBuilder(
                                                          pageBuilder: (_, __, ___) => NavBar(1)));
                                                    },
                                                  ),
                                                ],
                                              );});



                                        }, icon:  Icon(Icons.delete_forever, color: Colors.green),
                                      ),
                                    ]
                                )
                            ),

                          ]
                      );
                    }
                )
            );
          }
        }
    );
  }

  IconData? goodIcon(String string) {
    if (string == "medoc")
      return Icons.healing;
    if (string == "vaccin")
      return Icons.vaccines_outlined;
  }

  static String getNameRappel(List<Map<String, Object?>> rappelByName, Map<String, Object?> Myrappel) {
    String idProfile = Myrappel["id_profile"].toString();
    for (Map<String, Object?> people in rappelByName){
      List<Map<String, Object?>> rappels = people["rappel"] as List<Map<String, Object?>>;
      for (Map<String, Object?> rappel in rappels){
        if (rappel["id_profile"].toString() == idProfile){
          return people["name"].toString();
        }
      }
    }
    return "Got a prb Huston";
  }

  static String getNameProduit(Map<String, Object?> rappel) {
    return rappel["name"].toString();
  }



  String getDateEnd(Map<String, Object?> rappel) {
    if (rappel["status"].toString() == "vaccin")
      return "";
    if (rappel["status"].toString() == "medoc") {
      int periode = int.parse(rappel["periode"].toString());
      DateTime date = stringToDateTime(rappel["date"].toString());
      DateTime newDate = date.add(Duration(days: periode));
      String dateVal = dateTimeToString(newDate);
      return "to : " + dateVal;
    }
    return "";
  }
}