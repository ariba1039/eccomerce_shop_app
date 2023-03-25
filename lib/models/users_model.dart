class UsersModel {
  UsersModel({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.avatar,
  });

  final int id;
  final String email;
  final String password;
  final String name;
  final String role;
  final String avatar;

  UsersModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        password = json['password'],
        name = json['name'],
        role = json['role'],
        avatar = json['avatar'];

  static List<UsersModel> usersFromList(List<Map<String, dynamic>> users) {
    return users.map(UsersModel.fromJson).toList();
  }
}
