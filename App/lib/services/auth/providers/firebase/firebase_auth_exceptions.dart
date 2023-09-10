// Login exception: Thrown when a user with these credentials is not found.
class UserNotFoundAuthException implements Exception {}

// Login exception: Thrown when either the password or the email entered is wrong.
class WrongCredentialsAuthException implements Exception {}

// Login && Registration exception: Thrown when the email entered is invalid.
class InvalidEmailAuthException implements Exception {}

// Registration exception: Thrown when the email is already registered.
class EmailInUseAuthException implements Exception {}

// Registration exception: Thrown when the password is too weak.
class WeakPasswordAuthException implements Exception {}

// A generic exception that is thrown in the default case.
class GenericAuthException implements Exception {
  final String _code;
  GenericAuthException(this._code);
  String get code => _code;
}

// Thrown by Firebase or any other authentication provider if user is found
// to not be logged in at any point.
class UserNotLoggedInException implements Exception {}