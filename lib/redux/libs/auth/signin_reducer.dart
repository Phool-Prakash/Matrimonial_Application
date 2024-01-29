import 'package:matrimonial_app/redux/libs/auth/signin_action.dart';
import 'package:matrimonial_app/redux/libs/auth/signin_state.dart';

SignInState? sign_in_reducer(SignInState? state, dynamic action) {
  if (action is SignInAction) {
    return loader(state, action);
  }
  if (action is IsPhoneOrEmailChangeAction) {
    return is_phone_or_email(state!, action);
  }
  if (action is SetPhoneNumberAction) {
    state!.phoneNumber = action.payload;
    return state;
  }
  if (action is IsObscureAction) {
    state!.isObscure = !state.isObscure!;
    return state;
  }

  return state;
}

class IsPhoneOrEmailChangeAction {}

is_phone_or_email(SignInState state, ValueChanger) {
  state.isPhone = !state.isPhone!;
  return state;
}

loader(SignInState? state, SignInAction action) {
  if (action.from == "custom") {
    state!.isCustomLogin = !state.isCustomLogin!;
  } else {
    state!.isLogin = !state.isLogin!;
  }
  return state;
}
