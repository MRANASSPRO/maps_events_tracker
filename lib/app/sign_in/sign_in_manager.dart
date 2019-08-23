import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
//import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/auth_service.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});

  final AuthService auth;
  final ValueNotifier<bool> isLoading;

  /*Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }*/
}

/*class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}*/