import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String userId;
  final String username;
  final String email;
  final String profileImageUrl;
  final String bio;
  final DateTime createdAt;

  const AppUser({
    required this.userId,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.bio,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        email,
        profileImageUrl,
        bio,
        createdAt,
      ];

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      userId: id,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      bio: map['bio'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppUser copyWith({
    String? userId,
    String? username,
    String? email,
    String? profileImageUrl,
    String? bio,
    DateTime? createdAt,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}