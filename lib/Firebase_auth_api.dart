import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {
  final FirebaseAuth _auth= FirebaseAuth.instance;// me trae tod lo que existe en la consolo de firebase, toda la composicion, lo que deje definido

final GoogleSignIn googleSignIn=GoogleSignIn();// traigo tod lo de Google Sign In

Future<FirebaseUser> signIn() async{ // se usa async porque se va ejecutar un metodo en segudno plno
  GoogleSignInAccount googleSignInAccount= await googleSignIn.signIn();//solicito el cuadro de dialogo que pide la cuanto con la cual me voy a registrar
  GoogleSignInAuthentication gSA= await googleSignInAccount.authentication; // se guardan las credenciales
  FirebaseUser user= (await _auth.signInWithCredential(GoogleAuthProvider.getCredential(idToken: gSA.idToken, accessToken: gSA.accessToken))) as FirebaseUser;// se hace la autenticacion con firebase

  return user;
}

signOut() async{
  await _auth.signOut().then((onValue)=> print("Sesión cerrada"));
  googleSignIn.signOut();
  print("Cerrado");
}

}