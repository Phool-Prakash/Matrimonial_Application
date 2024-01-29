import 'package:matrimonial_app/const/my_theme.dart';
import 'package:matrimonial_app/helpers/navigator_push.dart';
import 'package:matrimonial_app/redux/app/app_state.dart';
import 'package:matrimonial_app/redux/libs/auth/forgetpassword_reducer.dart';
import 'package:matrimonial_app/repository/auth_repository.dart';
import 'package:matrimonial_app/screens/auth/change_password.dart';
import 'package:matrimonial_app/screens/auth/forget_password.dart';
import 'package:matrimonial_app/screens/auth/new_password.dart';
import 'package:matrimonial_app/screens/auth/verify.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../helpers/show_message_state.dart';

ThunkAction<AppState> forgetPasswordMiddleware({required BuildContext context,email, send_by,bool isResend=false}) {
  return (Store<AppState> store) async {
    store.dispatch(FpLoader());

    try {
      var data =
          await AuthRepository().forgetPassword(email: email, send_by: send_by);
      if (data.result) {
        store.dispatch(
            ShowMessageAction(msg: data.message, color: MyTheme.success));
        //check is it request for resend otp or not
        if(!isResend)
        NavigatorPush.push(context, NewPassword(sendBy: send_by,emailOrPhone: email,));
      } else {
        NavigatorPush.push(context, NewPassword(sendBy: send_by,emailOrPhone: email,));

        store.dispatch(
            ShowMessageAction(msg: data.message, color: MyTheme.failure));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    store.dispatch(FpLoader());
  };
}
