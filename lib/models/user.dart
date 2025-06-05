class User {
  final String name;
  final String password;
  final bool isAdmin;

  User({
    required this.name,
    required this.password,
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['username'],
      password: '',
      isAdmin: json['is_admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'username': name,
    'password': password
  };
}
