import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? userId;
  String? token;
  DateTime? expiryDate;
  Timer? timer;

  String? get getToken {
    if (token != null &&
        expiryDate!.isAfter(DateTime.now()) &&
        expiryDate != null) {
      return token;
    }
    return null;
  }

  String? get getUserId {
    return userId;
  }

  bool get isAuth {
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> authenticate(String email, String password, String diff) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$diff?key=AIzaSyCa5tp4Dqexs3hcS_gCaAKGC7nOzJQ-n8I';

    try {
      final response = await http.post(
        url as Uri,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } else {
        token = responseData['idToken'].toString();
        userId = responseData['localId'].toString();
        expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(
              responseData['expiresIn'].toString(),
            ),
          ),
        );
      }
      autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    userId = null;
    expiryDate = null;
    token = null;
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    notifyListeners();
  }

  void autoLogout() {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(
        Duration(
          seconds: expiryDate!.difference(DateTime.now()).inSeconds,
        ),
        logout);
  }
}
