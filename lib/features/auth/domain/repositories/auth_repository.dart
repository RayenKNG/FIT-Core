// Sesuai modul hal.47
abstract class AuthRepository {
  Future<String> verifyFirebaseToken(String firebaseToken);
}
