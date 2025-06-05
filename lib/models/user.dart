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
      name: json['name'],
      password: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'token': password
  };
}
