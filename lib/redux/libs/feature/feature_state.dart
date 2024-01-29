import 'package:matrimonial_app/models_response/feature_check_response.dart';

class SystemSettingState {
  SystemSettingResponse? settingResponse;

  SystemSettingState({this.settingResponse});

  SystemSettingState.initialState() : settingResponse = null;
}
