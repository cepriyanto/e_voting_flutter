class UserModel {
  final String name;
  final String nim;
  final String prodi;
  final String password;

  UserModel({
    required this.name,
    required this.nim,
    required this.prodi,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      nim: json['nim'] as String,
      prodi: json['prodi'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nim': nim,
      'prodi': prodi,
      'password': password,
    };
  }
}
