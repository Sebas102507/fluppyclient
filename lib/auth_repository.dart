import 'package:firebase_auth/firebase_auth.dart';
import 'Firebase_auth_api.dart';
class AuthRepository { // se usa para swichear la fuente de datos, gmail , facebook, etc
  final _firebaseAuthAPI= FirebaseAuthAPI();
  Future<FirebaseUser> signInFirebase(){
    _firebaseAuthAPI.signIn();
  }
  signOut()=>_firebaseAuthAPI.signOut();

}