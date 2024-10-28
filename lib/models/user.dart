class User {
  final String name;
  final String email;
  final String password;
  final DateTime? birthday;
  final String? gender;
  final String? profileUrl;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.birthday,
    this.gender,
    this.profileUrl,
  });

  // Method to convert a JSON object to a User instance
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      gender: json['gender'],
      profileUrl: json['profile_url'],
    );
  }

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'profile_url': profileUrl,
    };
  }
}
