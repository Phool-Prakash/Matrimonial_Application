import 'dart:convert';

import 'package:matrimonial_app/app_config.dart';
import 'package:matrimonial_app/const/const.dart';
import 'package:matrimonial_app/models_response/common_response.dart';
import 'package:matrimonial_app/screens/startup_pages/splash_screen.dart';
import 'package:http/http.dart' as http;

class ReportRepository {
  Future<CommonResponse> report({int? userId, dynamic reason}) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/report-member";
    var accessToken = prefs.getString(Const.accessToken);

    var postBody = jsonEncode({"user_id": userId, "reason": reason});
    var response = await http.post(Uri.parse(baseUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: postBody);

    var data = commonResponseFromJson(response.body);

    return data;
  }
}
