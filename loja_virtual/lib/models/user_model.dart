import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {
  bool _loggedWithGoogle = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((usercred) async {
      firebaseUser = usercred.user;
      await _loadCurrentUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((usercred) async {
      firebaseUser = usercred.user;
      await _saveUserData(userData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void signOut() async {
    if (_loggedWithGoogle) {
      googleSignIn.signOut();
      _loggedWithGoogle = false;
    } else {
      _auth.signOut();
    }
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<User> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken);
      final UserCredential firebaseAuth = await FirebaseAuth.instance
          .signInWithCredential(googleAuthCredential);
      _loggedWithGoogle = true;
      this.firebaseUser = firebaseAuth.user;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .get();
      await _loadCurrentUser();
      if (doc.exists) {
        await _saveUserData({
          "name": firebaseUser.displayName,
          "email": firebaseUser.email,
          "phone": userData["phone"],
          "adress": userData["adress"]
        });
      } else {
        await _saveUserData({
          "name": firebaseUser.displayName,
          "email": firebaseUser.email,
          "phone": null,
          "adress": null
        });
      }

      return firebaseUser;
    } catch (e) {
      return null;
    }
  }

  Future<Null> updateUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .update(userData);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .set(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser;
    } else {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .get();
        this.userData = docUser.data();

        notifyListeners();
      }
    }
  }
}
