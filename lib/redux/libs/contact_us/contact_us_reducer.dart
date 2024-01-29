import 'package:matrimonial_app/enums/enums.dart';
import 'package:matrimonial_app/redux/libs/contact_us/contact_us_state.dart';

ContactUsState? contact_us_reducer(ContactUsState? state, dynamic action) {
  if (action == SaveChanges.contactUs) {
    state!.isSubmit = !state.isSubmit;
    return state;
  }

  return state;
}
