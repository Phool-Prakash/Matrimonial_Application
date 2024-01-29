import 'package:matrimonial_app/models_response/drop_down/profile_dropdown_response.dart';

class ProfiledropdownState {
   ProfiledropdownResponse? profiledropdownResponse;

  ProfiledropdownState({this.profiledropdownResponse});

  ProfiledropdownState.initialState()
      : profiledropdownResponse = ProfiledropdownResponse.initialState();
}
