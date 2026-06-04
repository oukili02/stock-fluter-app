class User {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
