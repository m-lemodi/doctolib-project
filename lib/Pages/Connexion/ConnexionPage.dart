import 'package:flutter/material.dart';

import '../../Database/MyDatabase.dart';
import '../../main.dart';
import '../../utils/MyCheckBox.dart';




final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
bool isChecked = false;


class ConnexionPage extends StatefulWidget {
  const ConnexionPage({Key? key}) : super(key: key);

  @override
  _ConnexionPage createState() => _ConnexionPage();
}

class _ConnexionPage extends State<ConnexionPage> {
  bool _clicked = false;
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
          title: Text("Umbrella - Connexion"),
          backgroundColor: Colors.green

      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                MyCheckBox(onChecked: handleCheckBox,),
                Text("Rester connecter"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green
              ),
              onPressed: () async {
                if (await MyDatabase.tryConnection(emailController.text, passwordController.text, context)) {
                  id_account = await MyDatabase.getId(emailController.text);
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => MainPage()));
                } else{
                  setState(() {
                    _clicked = true;
                  });
                  print("error");
                }
              },

              child: const Text('Se connecter'),
            ),
            if (_clicked)
              const Text('Invalid Email or MDP' , style: TextStyle(
                color: Colors.red,
                fontSize: 12.0,
              ),
              ),
          ],
        ),
      ),
    );
  }
}
