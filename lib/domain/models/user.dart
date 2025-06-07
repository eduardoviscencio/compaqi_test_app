class User {
  final String name;
  final String email;
  final String picture;

  User({required this.name, required this.email, required this.picture});

  @override
  String toString() {
    return 'User(name: $name, email: $email, picture: $picture)';
  }
}
