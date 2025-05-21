import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:trackmate/core/common/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    super.photoUrl,
    super.username,
    super.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, [String? id]) {
    return UserModel(
      id: id ?? json['id'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      username: json['username'] as String,
      location: json['location'] as GeoPoint,
    );
  }

  factory UserModel.fromFirebaseUser(firebase_auth.User? user) {
    return UserModel(
      id: user!.uid,
      email: user.email!,
      photoUrl: user.photoURL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'photoUrl': photoUrl,
      'username': username,
      'location': location,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? photoUrl,
    String? username,
    GeoPoint? location,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      username: username ?? this.username,
      location: location ?? this.location,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, photoUrl: $photoUrl, username: $username)';
  }
}
