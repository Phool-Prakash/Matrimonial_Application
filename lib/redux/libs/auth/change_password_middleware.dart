import 'package:matrimonial_app/const/my_theme.dart';
import 'package:matrimonial_app/redux/app/app_state.dart';
import 'package:matrimonial_app/redux/libs/auth/change_password_reducer.dart';
import 'package:matrimonial_app/redux/libs/helpers/show_message_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../../repository/auth_repository.dart';

ThunkAction<AppState> changePasswordMiddlware({old, new_, confirm}) {
  return (Store<AppState> store) async {
    store.dispatch(CpLoader());

    try {
      var data = await AuthRepository()
          .changePassword(old: old, new_: new_, confirm: confirm);

      if (data.result!) {
        store.dispatch(
            ShowMessageAction(msg: data.message, color: MyTheme.success));
      } else {
        store.dispatch(
            ShowMessageAction(msg: data.message, color: MyTheme.failure));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    store.dispatch(CpLoader());
  };
}
