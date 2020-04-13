import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockingbirdapp/models/user.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      return _userFromFirebaseUser(firebaseUser);
    } catch(e){
      print(e.toString());
      return null;
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
}