
import 'package:flutter/material.dart';

import 'ConnexionPage.dart';
import 'RegisterPage.dart';

class HomeConnexionPage extends StatelessWidget {
  HomeConnexionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : MainConnexionPage(),
    );
  }
}

class MainConnexionPage extends StatelessWidget {
  const MainConnexionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text( " Suivie Vaccin Patient"),
      ),
      body: Center(
        child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('lib/Assets/famille.jpg')),
              SizedBox(height: 10.0),
              ElevatedButton (

                style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 50),
                  backgroundColor: Colors.green
                ),
                onPressed: () {
                  print("click button Connexion");
                  Navigator.push(context,PageRouteBuilder(pageBuilder: (_,__,___) => ConnexionPage()));
                },
                child: const Text("Connexion"),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(150, 50),
                      backgroundColor: Colors.green

                  ),
                  onPressed: () {
                    print("clcik button Register");
                    Navigator.push(context, PageRouteBuilder(pageBuilder: (_,__,___) => RegisterPage()));
                  }, child: const Text("Register")),
            ]
        ),
      ),
    );
  }
}
