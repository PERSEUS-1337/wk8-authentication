import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class FirebaseAuthAPI {
  /// Creating a singleton instance of the FirebaseAuth class.
  static final FirebaseAuth auth = FirebaseAuth.instance;
  /// Creating a singleton instance of the FirebaseFirestore class.
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // final db = FakeFirebaseFirestore();
  // final auth = MockFirebaseAuth(
  //     mockUser: MockUser(
  //   isAnonymous: false,
  //   uid: 'someuid',
  //   email: 'charlie@paddyspub.com',
  //   displayName: 'Charlie',
  // ));

  /// This function returns a stream of users, and the stream will emit a new user whenever the user changes.
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  /// A function that takes in two parameters, email and password, and returns a Future.
  ///
  /// Args:
  ///   email (String): The email address of the user.
  ///   password (String): The password of the user.
  void signIn(String email, String password) async {
    /// A variable that is used to store the result of the `signInWithEmailAndPassword` method.
    UserCredential credential;

    try {
      /// Assigning the result of the `signInWithEmailAndPassword` method to the `credential` variable.
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('No user found for that email.');
      } else if (e.code == 'wrong-pasword') {
        print('Wrong password provided for that user.');
      }
    }
  }

  /// A function that takes in two parameters, email and password, and returns a Future.
  /// 
  /// Args:
  ///   email (String): The email address of the user.
  ///   password (String): The password for the new account.
  void signUp(String email, String password) async {
    UserCredential credential;

    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  /// It signs out the user.
  void signOut() async {
    auth.signOut();
  }

  /// It saves the user to firestore.
  /// 
  /// Args:
  ///   uid (String): The user's unique ID.
  ///   email (String): The email of the user
  void saveUserToFirestore(String? uid, String email) async {
    try {
      await db.collection("users").doc(uid).set({"email": email});
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
