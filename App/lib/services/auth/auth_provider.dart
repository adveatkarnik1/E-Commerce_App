import 'package:ecommerce_app/models/auth_user.dart';

// This class is an interface that all our authentication providers like
// Firebase, Google, Apple and Facebook have to interact with.
abstract class AuthProvider {
  // Intializes the firebase app.
  Future<void> initializeTheApp();

  // A getter to get the current user.
  AuthUser? get currentUser;

  // This method takes the email and password and logs the user in.
  // It always returns an AuthUser upon await because if an exception occurs,
  // for example when the credentials are wrong, then an exception is thrown
  // that needs to be handled by the programmer. If no exceptions are thrown
  // then an AuthUser is always returned.
  Future<AuthUser> login({
    String email,
    String password,
  });

  // Logs out the user.
  Future<void> logout();

  // Similar to login(), except it creates a new user and returns
  // the AuthUser instance, or throwns an exception.
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  // Sends email verification.
  Future<void> sendEmailVerification();

  // Reloads the API's server.
  Future<void> reload();
}