import 'package:matrimonial_app/components/yes_no_dialog.dart';
import 'package:matrimonial_app/helpers/aiz_route.dart';
import 'package:matrimonial_app/helpers/localization.dart';
import 'package:matrimonial_app/helpers/main_helpers.dart';
import 'package:matrimonial_app/middleware/middleware.dart';
import 'package:matrimonial_app/models_response/common_models/user.dart';
import 'package:matrimonial_app/screens/package/premium_plans.dart';
import 'package:flutter/material.dart';

class ProfileViewMiddleware extends Middleware<bool, bool> {
  User? user;
  late BuildContext context;

  ProfileViewMiddleware({this.user, required this.context});

  @override
  bool next({bool? data}) {
    if (user?.membership != null &&
        user?.membership == 1 &&
        settingIsActive("full_profile_show_according_to_membership", "1")) {
      YesNoDialog.show(
          title:
              LangText(context: context).getLocal()!.please_update_your_package,
          content: LangText(context: context)
              .getLocal()!
              .please_update_your_package_des,
          yestTxt: LangText(context: context).getLocal()?.package_purchase,
          onClickYes: () => AIZRoute.push(context, PremiumPlans()));
      return false;
    }
    return true;
  }
}
