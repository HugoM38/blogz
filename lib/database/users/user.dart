class User {
  final String username;
  final String password;
  final String? imageUrl;

  User({required this.username, required this.password, this.imageUrl});

  factory User.fromMap(Map<String, dynamic> map) {
    if (map['imageUrl'] != null) {
      return User(
          username: map['username'],
          password: map['password'],
          imageUrl: map['imageUrl']);
    }
    return User(
      username: map['username'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'password': password, 'imageUrl': imageUrl};
  }
}
