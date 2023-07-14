import 'package:doctolib/Database/ProfileDataBase.dart';
import 'package:doctolib/main.dart';
import 'package:doctolib/utils/style.dart';
import 'package:flutter/material.dart';


class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  List<Map<String, Object?>> profiles = [];

  @override
  void initState() {
    super.initState();
    fetchProfiles(id_account); // Appel de la fonction pour récupérer les profils au chargement de la page
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = buildProfileWidgets();
    return Column(children: widgets);
  }

  Future<void> fetchProfiles(idAccount) async {
    List<Map<String, Object?>> fetchedProfiles = await ProfileDataBase.getFamille(idAccount); // Exemple d'appel à une méthode de service de base de données

    setState(() {
      profiles = fetchedProfiles; // Mettre à jour la liste des profils avec les données récupérées
    });
  }

  void showProfile(BuildContext context, profile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: () => print("Image"), icon: pickIcon(profile['status'].toString()), iconSize: double.tryParse("64")),
              Text(profile['prenom'].toString()),
              Text(profile['birthday'].toString()),
              Text(profile['status'].toString()),
              Text("Poids : " + profile['poids'].toString() + "kg"),
              Text("Taille : " + profile['taille'].toString() + "cm"),
              // Ajoutez d'autres informations de profil ici
            ],
          ),
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

  List<Widget> buildProfileWidgets() {
    var widgets = profiles.map((profile) {
      return Container(
        decoration: box,
        height: 64,
        width: 387,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 8),
              pickIcon(profile['status'].toString()),
              SizedBox(width: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(profile['prenom'].toString()),
                  SizedBox(height: 10,),
                  Text(profile['birthday'].toString()),
                ],
              ),
              Flexible(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                        onPressed: () => showProfile(context, profile),
                        child: Text("Voir le profil"),
                        // style: ButtonStyle(backgroundColor: Colors.green),
                      )
                    ]
                ),
              ),
              SizedBox(width: 8,)
            ],
          ),
        ),
      );
    }).toList();
    List<Widget> res = [];

    for (var idx in widgets) {
      res.add(SizedBox(height: 8.0));
      res.add(idx);
    }

    return res;
  }

  Icon pickIcon(status){
    if (status == "Parent") {
      return Icon(Icons.man);
    }
    else if (status == "Enfant") {
      return Icon(Icons.child_care);
    }
    else if (status == "Animal") {
      return Icon(Icons.pets);
    }
    return Icon(Icons.question_mark);
  }


}
