import 'package:doctolib/Pages/ProfilePage.dart';
import 'package:flutter/material.dart';
import '../main.dart';

import '../Database/ProfileDataBase.dart';
import '../utils/NavBar.dart';
import '../utils/utilsFct.dart';

class FamillePage extends StatefulWidget{

  @override
  State<FamillePage> createState() => _FamillePage();

}

class _FamillePage extends State<FamillePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => addProfile(),
              icon: Icon(Icons.add_circle),
              color: Colors.green,
              iconSize: 50,
            ),
            Container(
              width: double.infinity,
              child: Profile(),
            ),
          ],
        ),
      ),
    );
  }



// Déclarations des variables pour les champs de saisie
  TextEditingController _nomController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  late MyDateField birthdate;

  // Liste des options de choix
  List<String> options1 = ['Parent', 'Enfant', 'Animal'];
  // Variable pour stocker la valeur sélectionnée
  String? selectedOption1;
  // Fonction appelée lorsqu'une option est sélectionnée
  void _onOptionSelected1(String? value) {
    setState(() {
      selectedOption1 = value;
    });
  }

  // Liste des options de choix
  List<String> options2 = ['Homme', 'Femme', 'Autre'];
  // Variable pour stocker la valeur sélectionnée
  String? selectedOption2;
  // Fonction appelée lorsqu'une option est sélectionnée
  void _onOptionSelected2(String? value) {
    setState(() {
      selectedOption2 = value;
    });
  }


// Widget DropdownButton

// Fonction pour ouvrir le popup
  void addProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un profil'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                  ),
                ),

                SizedBox(height: 16),
                DropdownButtonFormField(
                    value: selectedOption1,
                    items: options1.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption1 = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Statut',
                      border: OutlineInputBorder(),

                    )
                ),
                
                SizedBox(height: 16),
                DropdownButtonFormField(
                    value: selectedOption2,
                    items: options2.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption2 = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Sexe',
                      border: OutlineInputBorder(),

                    )
                ),

                SizedBox(height: 16),
                birthdate = MyDateField('Date de naissance'),

                SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Poids (kg)',
                      hintText: 'Entrez votre poids en Kg'

                  ),
                  validator: (value) {
                    // Validation personnalisée pour s'assurer que la valeur est numérique
                    if (value!.isEmpty) {
                      return 'Veuillez saisir une valeur';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Veuillez saisir une valeur numérique valide';
                    }
                    return null; // La valeur est valide
                  }
                  ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Taille (cm)',
                      hintText: 'Entrez votre taille en cm'

                  ),
                  validator: (value) {
                    // Validation personnalisée pour s'assurer que la valeur est numérique
                    if (value!.isEmpty) {
                      return 'Veuillez saisir une valeur';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Veuillez saisir une valeur numérique valide';
                    }
                    return null; // La valeur est valide
                  },
                ),
              ],
            ),
              ),
            actions: [
               TextButton(
               onPressed: () {
             // Action à effectuer lorsque le bouton est pressé
             Navigator.of(context).pop(); // Ferme le popup
             },
             child: Text('Fermer'),
            ),
              TextButton(onPressed: () => sendProfileToDatabase(_nomController.text,
                selectedOption2!, _heightController.text, _weightController.text,
                  selectedOption1!, birthdate.getSelectedDate()),
                  child: Text("Confirmer"))
          ]
        );
      },
    );
    print(selectedOption2);

  }


  //id_account est hardcode dans main
  final Future<List<Map<String, Object?>>> famille =  ProfileDataBase.getFamille(id_account);

  void sendProfileToDatabase(String name, String gender, String height,
      String weight, String status, String age) async {
    print('Ajout du profil :\nNom : ' + name + '\nGenre : ' + gender +
    '\nStatut : ' + status + '\nTaille : ' + height + '\nPoids : ' + weight);
    
    await ProfileDataBase.addElementProfileTable(id_account, age, name,
        gender, status, int.parse(weight), int.parse(height));
    Profile();
    Navigator.pop(context);
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => NavBar(2)));
  }



}

