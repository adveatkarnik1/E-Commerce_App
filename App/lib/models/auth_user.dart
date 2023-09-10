import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

// This class is a blueprint of a user instance in our backend.
// The fromFirebase() factory constructor allows us to configure our AuthUser
// to have the same details in our Firebase backend, without making any
// API calls directly in the UI layer of our application.
@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}