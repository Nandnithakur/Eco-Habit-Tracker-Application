class UserModel {
  final String name;
  final String email;
  final String? bio;

  UserModel({
    required this.name,
    required this.email,
    this.bio,
  });
}
