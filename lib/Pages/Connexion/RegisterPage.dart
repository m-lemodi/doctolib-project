import 'package:flutter/material.dart';

import '../../Database/MyDatabase.dart';
import '../../utils/Validator.dart';



final _email = TextEditingController();
final _password = TextEditingController();
final _confimrpassword = TextEditingController();

bool isPasswordEqual(){
  return _password.text == _confimrpassword.text;
}

class RegisterPage extends StatefulWidget{
  @override
  RegisterPageWidget createState() => RegisterPageWidget();
}

class RegisterPageWidget extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  /*@override
  void dispose(){
    _email.dispose();
    _password.dispose();
    _confimrpassword.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    String status = "patient";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text( "Umbrella - Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: validateInputEmail,
                keyboardType: TextInputType.emailAddress,
                controller :  _email,
              ),
              SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: validateNotEmpty,
                controller : _password,

              ),
              SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: validateInputPassword,
                controller: _confimrpassword,
              ),
              SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                ),
                  child: Text('Register'),

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Register")));
                      MyDatabase.addElementAccountTable(_email.text, _password.text);
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
