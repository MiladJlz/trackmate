import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/error/exceptions.dart';

abstract class SocialRemoteDataSource {
  Future<List<UserEntity>> searchUser(String username);
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
  Future<List<String>> getFollowers();
  Future<List<String>> getFollowings();
  Stream<List<UserEntity>> getFollowingsLocation();
  Future<void> updateLocation(GeoPoint location);
}

class SocialRemoteDataSourceImpl implements SocialRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth firebaseAuth;

  SocialRemoteDataSourceImpl({
    required this.fireStore,
    required this.firebaseAuth,
  });

  @override
  Future<List<UserEntity>> searchUser(String username) async {
    try {
      final QuerySnapshot result =
          await fireStore
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: username)
              .where('username', isLessThanOrEqualTo: '$username\uf8ff')
              .limit(10)
              .get();

      return result.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserEntity(
          id: doc.id,
          email: data['email'] as String,
          photoUrl: data['photoUrl'] as String?,
          username: data['username'] as String,
        );
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> followUser(String userId) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw ServerException('کاربر وارد نشده است');
      }

      await fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('followings')
          .doc(userId)
          .set({'timestamp': FieldValue.serverTimestamp()});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unfollowUser(String userId) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw ServerException('کاربر وارد نشده است');
      }

      await fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('followings')
          .doc(userId)
          .delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getFollowers() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw ServerException('کاربر وارد نشده است');
      }
      final result =
          await fireStore
              .collection('users')
              .doc(currentUser.uid)
              .collection('followers')
              .get();
      List<String> followers = List.generate(
        result.docs.length,
        (index) => result.docs[index].id,
      );
      return followers;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getFollowings() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw ServerException('کاربر وارد نشده است');
      }
      final result =
          await fireStore
              .collection('users')
              .doc(currentUser.uid)
              .collection('followings')
              .get();

      List<String> followings = List.generate(
        result.docs.length,
        (index) => result.docs[index].id,
      );
      return followings;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<UserEntity>> getFollowingsLocation() async* {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw ServerException('User not logged in');
      }

      // Get initial list of followings
      final followings = await getFollowings();

      if (followings.isEmpty) {
        yield [];
        return;
      }

      // Create a stream that listens to all followed users
      yield* fireStore
          .collection('users')
          .where(FieldPath.documentId, whereIn: followings)
          .snapshots()
          .asyncMap((querySnapshot) {
            return querySnapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return UserEntity(
                id: doc.id,
                email: data['email'] as String,
                photoUrl: data['photoUrl'] as String?,
                username: data['username'] as String,
                location: data['location'] as GeoPoint?,
              );
            }).toList();
          });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateLocation(GeoPoint location) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw ServerException('کاربر وارد نشده است');
      }

      // Use update to modify only the 'location' field
      await fireStore.collection('users').doc(currentUser.uid).update({
        'location': location,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
