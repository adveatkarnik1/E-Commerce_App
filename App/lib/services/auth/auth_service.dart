import 'package:ecommerce_app/services/auth/providers/firebase/firebase_auth_provider.dart';
import 'package:ecommerce_app/services/auth/auth_provider.dart';
import 'package:ecommerce_app/models/auth_user.dart';

// We need another layer between the UI and the API other than
// and above the provider layer because it helps to take data from
// the provider and keep information more organised for the UI to render.
// * Interacts with the UI that sits above it and the providers
// * that all sit below it.
class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initializeTheApp() => provider.initializeTheApp();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({
    String email = "",
    String password = "",
  }) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> reload() => provider.reload();
}

extension GetUser on AuthService {
  Future<AuthUser?> getUser() {
    final user = provider.currentUser;
    if (user == null) {
      return Future(() => null);
    }
    return Future(() => user);
  }
}