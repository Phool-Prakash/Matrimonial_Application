import 'dart:convert';

import 'package:matrimonial_app/app_config.dart';
import 'package:matrimonial_app/const/my_theme.dart';
import 'package:matrimonial_app/main.dart';
import 'package:matrimonial_app/models_response/common_response.dart';
import 'package:matrimonial_app/redux/libs/helpers/show_message_state.dart';
import 'package:matrimonial_app/screens/startup_pages/splash_screen.dart';
import 'package:http/http.dart' as http;

import '../const/const.dart';
import '../redux/libs/manage_profile/manage_profile_middleware/manage_profile_get_middlewares.dart';

class CareerRepository {
  Future<CommonResponse> postCareerStatus({id, required status}) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/career-status/update";
    var accessToken = prefs.getString(Const.accessToken);

    var postBody = jsonEncode({
      "status": status ? 1 : 0,
      "id": id,
    });

    var response = await http.post(Uri.parse(baseUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: postBody);

    var responseBody = commonResponseFromJson(response.body);

    if (responseBody.result == true) {
      store.dispatch(careerGetMiddleware());

      store.dispatch(
          ShowMessageAction(msg: responseBody.message, color: MyTheme.success));
    } else {
      store.dispatch(
          ShowMessageAction(msg: responseBody.message, color: MyTheme.failure));
    }

    return responseBody;
  }
}
