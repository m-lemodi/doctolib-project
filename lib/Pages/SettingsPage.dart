import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/MyCheckBox.dart';

class SettingsPage extends StatefulWidget{

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage>{
  String? selectedLangue;
  bool isCheckBoxChecked = false;

  void handleCheckBox(bool value) {
    setState(() {
      isCheckBoxChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Umbrella - Settings"),
      ),
          body: Padding(
            padding: EdgeInsets.all(12.0),
            child :
            Column(

            children :[
              SizedBox(height: 18.0,),
              DropdownButtonFormField(
                  value: selectedLangue,
                  items: ["Français","Anglais"].map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: 'Saisir la langue',
                    border: OutlineInputBorder(),

                  ),
                  onChanged: (String? newValue) {
                       setState(() {
                         selectedLangue = newValue!;
                          });
                        }
              ),
              SizedBox(height: 18.0,),
              Row(
                children: [
                  MyCheckBox(  onChecked: handleCheckBox,),
                  Text("Activer Notification"),
                ],
              ),
              Row(
                children: [
                  MyCheckBox(  onChecked: handleCheckBox,),
                  Text("Activer DarkMode"),
                ],
              ),

              Row(
                children: [
                  MyCheckBox(  onChecked: handleCheckBox,),
                  Text("Activer Notification"),
                ],
              ),
              Visibility(
                visible: isCheckBoxChecked,
                child:  const Image(image: AssetImage('lib/Assets/Spectrum-RFVF.png')),

              ),

           ]
          )
    ));
  }
}