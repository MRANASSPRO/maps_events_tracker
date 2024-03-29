import 'dart:async';
import 'package:meta/meta.dart';

@immutable
class User {
  const User({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
    this.isEmailVerified,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
  final bool isEmailVerified;

}

abstract class AuthService {
  Future<User> currentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  void dispose();
/*Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();*/
}
