import 'package:flutter/material.dart';

class SignInState {
  bool? isLogin;
  bool? isCustomLogin;
  bool? isPhone;
  var phoneNumber;
  bool? isObscure;

  // controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInState({
    this.isLogin,
    this.isPhone,
    this.isObscure,
    this.isCustomLogin,
  });

  SignInState.initialState()
      : isPhone = false,
        isObscure = true,
        isCustomLogin = false,
        isLogin = false;
}
