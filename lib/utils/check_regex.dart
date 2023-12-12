bool checkRegex(String password) {
  return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
}
