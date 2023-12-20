import 'package:email_validator/email_validator.dart';

Map<String, dynamic> validateEmail(String email) {
  String error = "";

  if (!EmailValidator.validate(email)) {
    error = "el correo electrónico no es valido";
  }
  return {"success": error.isEmpty, "error": error};
}