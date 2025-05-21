import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String id;
  final String email;
  final String? photoUrl;
  final String? username;
  GeoPoint? location;

  UserEntity({
    required this.id,
    required this.email,
    this.photoUrl,
    this.username,
    this.location,
  });
}
