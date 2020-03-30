import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_web/const/device_width.dart';
import 'package:movie_web/models/user.dart';
import 'package:rxdart/subjects.dart';

class UserService {
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
