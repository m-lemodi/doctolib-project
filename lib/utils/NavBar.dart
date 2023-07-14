import 'package:doctolib/Pages/FamillePage.dart';
import 'package:flutter/material.dart';

import '../Pages/DocumentPage.dart';
import '../Pages/Rappel.dart';
import '../Pages/SettingsPage.dart';


List<String> labels = ["Calendrier","Vaccin","Famille","Profil"];

class NavBar extends StatefulWidget {
   int selectedIndex = 0;
  NavBar(this.selectedIndex);

  @override
  State<NavBar> createState() => _NavBarState(selectedIndex);
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  _NavBarState(this._selectedIndex);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.lightGreen);

    List<Widget> _widgetOptions = <Widget>[

      Rappel(),
      FamillePage(),
      DocumentPage(),


    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Umbrella - " + labels[_selectedIndex]),
        actions: [

          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Settings"),
                  ),

                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  print("Settings menu is selected.");
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => SettingsPage()));
                }else if(value == 1){
                  print("Log out");
                }
              }
          ),


        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.vaccines_outlined),
            label: 'Vaccin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_present_rounded),
            label: 'Documents',

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}
