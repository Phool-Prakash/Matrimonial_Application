
import 'package:matrimonial_app/redux/libs/common/common_state.dart';
import 'package:matrimonial_app/redux/libs/common/country_states_acotions.dart';

CommonState? commonStateCountryReducer(CommonState? state,dynamic action) {
  if (action is AddCountries) {
    state?.update(countries: action.data);
    return state;
  }
  return state;
}
