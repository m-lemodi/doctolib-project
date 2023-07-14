import '../Pages/Connexion/RegisterPage.dart';


String? validateNotEmpty (String? value) {
  return (value == null || value.isEmpty  ) ? 'please enter a value' : null;
}

String? validatePassword(String? value){
  return(!isPasswordEqual()) ? "confirm pass-word est difrent du pass-word" : null;
}


String? isEmail(String? value){
  return(value != null  && !value.contains("@")) ? "email do not contain mail part ex : @gmail.com" : null;
}

String? isPhone(String? value){
  final valueWithoutSpaces = value?.replaceAll(' ', '');
  final regex = RegExp(r'^\d{10}$');
  return (!regex.hasMatch(valueWithoutSpaces!)) ? "ceci n'est pas un numéro de telephone conforme" : null;
}

List<String? Function(String?)> validatorsPassWord = [validateNotEmpty, validatePassword];
List<String? Function(String?)> validatorsEmail = [validateNotEmpty, isEmail];
List<String? Function(String?)> validatorsPhone = [validateNotEmpty, isPhone];

String? validateInputPhone(String? value) {
  for (final validator in validatorsPhone) {
    final error = validator(value);
    if (error != null) {
      return error;
    }
  }
  return null;
}

String? validateInputEmail(String? value) {
  for (final validator in validatorsEmail) {
    final error = validator(value);
    if (error != null) {
      return error;
    }
  }
  return null;
}


String? validateInputPassword(String? value) {
  for (final validator in validatorsPassWord) {
    final error = validator(value);
    if (error != null) {
      return error;
    }
  }
  return null;
}