Map<String, dynamic> validatePassword(String password1, String password2) {
  String error = "";

  if(password1 != password2){
    error = "las contraseñas no coinciden";
  }
  else if (password1.length < 7) {
    error = "la contraseña debe tener al menos 7 caracteres";
  }
  else if (!password1.contains(RegExp(r'[0-9]'))) {
    error = "la contraseña debe tener al menos 1 número";
  }
  return {"success": error.isEmpty, "error": error};
}
