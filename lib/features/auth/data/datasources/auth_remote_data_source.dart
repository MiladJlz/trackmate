import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:trackmate/core/common/data/models/user_model.dart';
import 'package:trackmate/core/error/exceptions.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUp(String email, String password);
  Future<UserModel> signIn(String email, String password);
  Future<void> logout();
  Future<UserModel?> get currentUser;
  Future<void> createUser(UserModel user);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });
  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserModel.fromFirebaseUser(credential.user);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? "Signup failed");
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(credential.user);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? "Login failed");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? "Logout failed");
    }
  }

  @override
  Future<UserModel?> get currentUser async {
    if (firebaseAuth.currentUser == null) return null;

    try {
      final userDoc =
          await firestore
              .collection("users")
              .doc(firebaseAuth.currentUser!.uid)
              .get();

      if (!userDoc.exists) return null;

      return UserModel.fromJson(userDoc.data()!,firebaseAuth.currentUser!.uid);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> createUser(UserModel user) async {
    await firestore
        .collection("users")
        .doc(user.id)
        .set(user.toJson())
        .onError(
          (error, stackTrace) => throw ServerException(error.toString()),
        );
  }
}
