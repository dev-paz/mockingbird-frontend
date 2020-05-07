import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:http/http.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User _userFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null ? User(firebaseUserId: firebaseUser.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e);
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      IdTokenResult firebaseIdToken = await firebaseUser.getIdToken();

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      try {
        Response response = await post(
            "https://mockingbird-backend.herokuapp.com/create_account",
            headers: requestHeaders,
            body: jsonEncode({
              "firebase_id_token": firebaseIdToken.token.toString(),
              "firebase_user_id": firebaseUser.uid,
            }
            )
        );
      } catch (e) {
        print(e);
        return null;
      }
      }catch(e){
      print(e);
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser firebaseUser = authResult.user;
      IdTokenResult firebaseIdToken = await firebaseUser.getIdToken();
      String googleIdToken = googleSignInAuthentication.idToken;

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      try {
        Response response = await post(
            "https://mockingbird-backend.herokuapp.com/create_account",
            headers: requestHeaders,
            body: jsonEncode({
              "firebase_id_token": firebaseIdToken.token.toString(),
              "firebase_user_id": firebaseUser.uid,
            }
          )
        );

      } catch (e) {
        print(e);
        return null;
      }
      return _userFromFirebaseUser(firebaseUser);
    }catch (e) {
      print(e);
      return null;
    }
  }
}