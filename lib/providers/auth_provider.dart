import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';

class AuthProvider with ChangeNotifier {
  /// A late variable. It is a variable that is initialized after the constructor is called.
  late FirebaseAuthAPI authService;
  
  User? userObj;

  /// The AuthProvider() function is called when the app starts. It creates an instance of the FirebaseAuthAPI class and then calls the getUser() function. 
  /// The getUser() function returns a stream of User objects. 
  /// The AuthProvider() function then listens to the stream and assigns the User object to the userObj variable
  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      /// A function that is called when the userObj variable is changed. 
      /// It tells the app that the userObj variable has changed and that the app needs to rebuild the widgets that use the userObj variable.
      notifyListeners();
    }, onError: (e) {
      // provide a more useful error
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  /// A getter function that returns the userObj variable.
  User? get user => userObj;
  
  /// A getter function that returns a boolean value. It returns true if the userObj variable is not null.
  bool get isAuthenticated {  
    return user != null;
  }

  /// It takes in two strings, email and password, and returns a Future.
  /// 
  /// Args:
  ///   email (String): The email address of the user.
  ///   password (String): The password of the user.
  void signIn(String email, String password) {
    authService.signIn(email, password);
  }

  /// It signs out the user.
  void signOut() {
    authService.signOut();
  }

  /// It takes in two parameters, email and password, and returns nothing.
  /// 
  /// Args:
  ///   email (String): The email address of the user.
  ///   password (String): The password for the new account.
  void signUp(String email, String password) {
    authService.signUp(email, password);
  }
}

