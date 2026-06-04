import 'package:stock_flutter/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    required String name,
    String? photoUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    id: id,
    email: email,
    name: name,
    photoUrl: photoUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
