import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_web/const/device_width.dart';
import 'package:movie_web/models/user.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService {
//  final GoogleAuthProvider
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  BehaviorSubject<User> _user$ = BehaviorSubject.seeded(null);
  Stream<User> get user$ => _user$.stream;

  login(String email, password) async {
    print('$defaultUrl/login');
    final response = await http.post('$defaultUrl/login',
        body: json.encode(
          {"email": email, "password": password},
        ));
    if (response.statusCode == 200) {
      _user$.add(User.fromJson(json.decode(response.body)));
    }
  }

  googleLogin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  Future<bool> signup(email, password, username, phone) async {
    //todo implement sign up
    final response = await http.post('$defaultUrl/user',
        body: json.encode(
          {
            "email": email,
            "password": password,
            'phone': phone,
            'username': username
          },
        ));
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  void dispose() {
    _user$.close();
  }
}
