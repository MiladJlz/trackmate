import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackmate/features/social/domain/entities/social_entity.dart';

class SocialModel extends SocialEntity {
  SocialModel({required super.followers, required super.following});

  copyWith({List<String>? followers, List<String>? following}) {
    return SocialModel(
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
