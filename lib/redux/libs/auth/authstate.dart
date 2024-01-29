import 'package:matrimonial_app/models_response/common_models/user.dart';

class AuthState{
  User? userData;
  AuthState({this.userData});
  AuthState update(User user){
    return AuthState(userData: userData);
  }
}