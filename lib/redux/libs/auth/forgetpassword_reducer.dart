import 'package:matrimonial_app/redux/libs/auth/forgetpassword_state.dart';

ForgetPasswordState? forgetpassword_reducer(
    ForgetPasswordState? state, dynamic action) {
  if (action is FpLoader) {
    return loader(state!, action);
  }

  return state;
}

class FpLoader {}

loader(ForgetPasswordState state, FpLoader action) {
  state.fp_loader = !state.fp_loader!;
  return state;
}
