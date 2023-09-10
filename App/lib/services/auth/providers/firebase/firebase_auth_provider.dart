import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/services/auth/providers/firebase/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/services/auth/auth_provider.dart';
import 'package:ecommerce_app/models/auth_user.dart';

// This class implements the create a user, log in a user, log out
// a user and send email verification to a user functionalities
// provided by Firebase.
// * It interacts with the Authentication Service layer that sits above it,
// * and the actual Firebase API that sits directly below it.
class FirebaseAuthProvider implements AuthProvider {
  // Initializes the app.
  @override
  Future<void> initializeTheApp() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyB6zTnXbM7uZIc4LSQ2MRgGvPcfAcmNZGw',
          appId: '1:274877030914:web:36ead5534991e49a21bd1b',
          messagingSenderId: '274877030914',
          projectId: 'my-grid-app-a9d91',
          authDomain: 'my-grid-app-a9d91.firebaseapp.com',
          storageBucket: 'my-grid-app-a9d91.appspot.com',
          measurementId: 'G-HBXFW8SB0H',
        ),
      );
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Creates a user.
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Gets and stores the user after we create it.
      final user = currentUser;
      if (user == null) {
        throw UserNotLoggedInException();
      }
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        // If the password is too weak.
        case "weak-password":
          throw WeakPasswordAuthException();

        // If a user already exists with the given credentials.
        case "email-already-in-use":
          throw EmailInUseAuthException();

        // If the email is invalid.
        case "invalid-email":
          throw InvalidEmailAuthException();

        // Any other firebase exception.
        default:
          throw GenericAuthException(e.code);
      }
    } catch (e) {
      // Any other exception.
      throw GenericAuthException(e.toString());
    }
  }

  // Gets the current user.
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return AuthUser.fromFirebase(user);
  }

  // Logs a user in.
  @override
  Future<AuthUser> login({
    String email = "",
    String password = "",
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Gets and stores the user anfter we log them in.
      final user = currentUser;
      if (user == null) {
        throw UserNotLoggedInException();
      }
      return user;
      // If the user is null, that means they are not logged in.
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        // If user is not found.
        case "user-not-found":
          throw UserNotFoundAuthException();

        // If the password is wrong.
        case "wrong-password":
          throw WrongCredentialsAuthException();

        // If the email is invalid.
        case "invalid-email":
          throw InvalidEmailAuthException();

        // Any other firebase exception.
        default:
          throw GenericAuthException(e.code);
      }
    } catch (e) {
      // Any other exception.
      throw GenericAuthException(e.toString());
    }
  }

  // Logs the current user out.
  @override
  Future<void> logout() async {
    final user = currentUser;
    if (user == null) {
      throw UserNotLoggedInException();
    }
    await FirebaseAuth.instance.signOut();
  }

  // Sends email verification to the current user.
  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw UserNotLoggedInException();
    }
    await user.sendEmailVerification();
  }

  @override
  Future<void> reload() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw UserNotLoggedInException();
    }
    await user.reload();
  }
}

extension GetUser on FirebaseAuthProvider {
  Future<AuthUser?> getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Future(() => null);
    }
    return Future(() => AuthUser.fromFirebase(user));
  }
}