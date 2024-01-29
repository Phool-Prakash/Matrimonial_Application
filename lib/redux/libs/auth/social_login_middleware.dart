import 'package:matrimonial_app/const/const.dart';
import 'package:matrimonial_app/const/my_theme.dart';
import 'package:matrimonial_app/helpers/navigator_push.dart';
import 'package:matrimonial_app/redux/app/app_state.dart';
import 'package:matrimonial_app/redux/libs/auth/signin_action.dart';
import 'package:matrimonial_app/redux/libs/home/home_middleware.dart';
import 'package:matrimonial_app/repository/auth_repository.dart';
import 'package:matrimonial_app/screens/auth/signin.dart';
import 'package:matrimonial_app/screens/auth/signup_verify.dart';
import 'package:matrimonial_app/screens/core.dart';
import 'package:matrimonial_app/screens/main.dart';
import 'package:matrimonial_app/screens/startup_pages/splash_screen.dart';
import 'package:flutter/material.dart';

import '../helpers/show_message_state.dart';

ThunkAction<AppState> socialLoginMiddleware({
  required BuildContext context,
  email,
  name,
  provider,
  secret_token = "",
  social_provider,
  access_token = "",
}) {
  return (Store<AppState> store) async {
    store.dispatch(SignInAction());

    try {
      var data = await AuthRepository().socialLogin(
        email: email,
        name: name,
        provider: provider,
        secret_token: secret_token,
        social_provider: social_provider,
        access_token: access_token,
      );

      store.dispatch(ShowMessageAction(
          msg: data.message,
          color: data.result == true ? MyTheme.success : MyTheme.failure));

      if (data.message == "Please verify your account") {
        NavigatorPush.push(context, SignupVerify());
      } else if (data.message == "Please wait for admin approval") {
        NavigatorPush.push(context, Login());
      }

      // store.dispatch(SignInResponse(
      //     result: data.result,
      //     message: data.message,
      //     accessToken: data.accessToken,
      //     tokenType: data.tokenType,
      //     expiresAt: data.expiresAt,
      //     user: data.user));

      if (data.result == true) {
        prefs.setBool(Const.prefIsLogin, true);
        prefs.setString(Const.accessToken, data.accessToken!);
        prefs.setString(Const.userName, data.user!.name!);
        prefs.setString(Const.maritalStatus, data.user!.maritalStatusId!.name!);
        prefs.setInt(Const.userId, data.user!.id!);
        prefs.setString(Const.userEmail,
            data.user!.email == null ? data.user!.phone! : data.user!.email!);
        prefs.setString(Const.userHeight, data.user!.height.toString());
        prefs.setString(Const.userAge, data.user!.birthday.toString());

        store.dispatch(homeMiddleware());
        NavigatorPush.push_remove_untill(page: Main());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    store.dispatch(SignInAction());
  };
}
