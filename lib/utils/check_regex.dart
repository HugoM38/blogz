bool checkRegex(String password) {
  //Check if password have 8 characters, 1 capital letter and 1 number
  return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
}
