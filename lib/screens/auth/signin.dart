import 'dart:convert';

// import 'package:matrimonial_app/TestScreen.dart';
import 'package:matrimonial_app/components/common_input.dart';
import 'package:matrimonial_app/components/my_gradient_container.dart';
import 'package:matrimonial_app/components/social_login_widget.dart';
import 'package:matrimonial_app/const/const.dart';
import 'package:matrimonial_app/const/my_theme.dart';
import 'package:matrimonial_app/const/style.dart';
import 'package:matrimonial_app/helpers/device_info.dart';
import 'package:matrimonial_app/helpers/main_helpers.dart';
import 'package:matrimonial_app/main.dart';
import 'package:matrimonial_app/redux/app/app_state.dart';
import 'package:matrimonial_app/redux/libs/auth/signin_action.dart';
import 'package:matrimonial_app/redux/libs/auth/signin_middleware.dart';
import 'package:matrimonial_app/redux/libs/auth/signin_reducer.dart';
import 'package:matrimonial_app/redux/libs/feature/feature_check_middleware.dart';
import 'package:matrimonial_app/screens/auth/forget_password.dart';
import 'package:matrimonial_app/screens/auth/signup.dart';
import 'package:matrimonial_app/screens/startup_pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../components/contact_faq_widget.dart';
import '../../redux/libs/helpers/show_message_state.dart';
import '../../redux/libs/staticPage/static_page.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // form key
  final _formKey = GlobalKey<FormState>();

  bool? isGoogle = settingIsActive('google_login_activation', '1');
  bool? isFacebook = settingIsActive('facebook_login_activation', '1');
  bool? isTwitter = settingIsActive('twitter_login_activation', "1");

  //
  bool? isOtpSystem = store.state.addonState!.data?.otpSystem ?? false;

  @override
  void initState() {
    store.dispatch(fetchStaticPageAction());
    prefs.setBool(Const.isView, true);
    store.dispatch(featureCheckMiddleware());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) => SizedBox(
            height: DeviceInfo(context).height,
            child: buildBody(context, state)),
      ),
    );
  }

  Widget buildBody(BuildContext context, AppState state) {
    return Stack(
      children: [
        buildGradientContainer(context),
        Positioned.fill(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 250,
                ),
                Container(
                  width: DeviceInfo(context).width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      // key form
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.signInState!.isPhone! ? "Phone" : "Email",
                            style: Styles.bold_app_accent_12,
                          ),
                          Const.height5,
                          state.signInState!.isPhone!
                              ? phone_field()
                              : email_field(),

                          Const.height5,
                          if (state.addonState?.data?.otpSystem ?? false)
                            email_or_phone(context, state),
                          Const.height5,
                          Text(
                            AppLocalizations.of(context)!.common_password_text,
                            style: Styles.bold_app_accent_12,
                          ),
                          Const.height5,

                          password_field(state),
                          Const.height5,

                          // forget password
                          forget_password(context),
                          const SizedBox(
                            height: 40,
                          ),
                          login_button(context, state),

                          const SizedBox(
                            height: 40,
                          ),

                          /// sign in if not have account to login
                          others(context, state),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget others(BuildContext context, AppState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.login_screen_if_have_account,
              style: Styles.regular_gull_grey_12,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUp(),
                  ),
                );
              },
              child: Text(
                ' ${AppLocalizations.of(context)!.login_screen_signup}',
                style: Styles.bold_app_accent_12,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),

        if (isGoogle! || isFacebook! || isTwitter!)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.login_screen_or_signup,
                style: Styles.regular_gull_grey_12,
              ),
            ],
          ),
        const SizedBox(
          height: 20,
        ),

        /// social button google facebook twitter
        // buildSocialLoginContainer(context, state)
        const SocialLoginWidget(),
        const SizedBox(
          height: 20,
        ),

        ContactAndFaq(
          title: "Frequently Asked Questions (FAQ)",
          content: state.staticPageState!.faq,
        )
      ],
    );
  }

  Widget login_button(BuildContext context, AppState state) {
    return InkWell(
      onTap: () => _login(state),
      child: MyGradientContainer(
        text: state.signInState!.isLogin == false
            ? Text(
                AppLocalizations.of(context)!.login_button_text,
                style: Styles.bold_white_14,
              )
            : CircularProgressIndicator(
                color: MyTheme.storm_grey,
              ),
      ),
    );
  }

  // _login(AppState state) async {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //
  //   if (!_formKey.currentState!.validate()) {
  //     store.dispatch(ShowMessageAction(msg: "Form's not validated!"));
  //   } else {
  //     try {
  //       final signInFunction = signInMiddleware(context);
  //       final response = await signInFunction(store);
  //
  //       print('Response from signInMiddleware: $response');
  //
  //       // Attempt to parse the response as JSON
  //       try {
  //         // Assuming your response is a JSON string, adjust this based on your actual response structure
  //         final jsonData = json.decode(response);
  //
  //         // Handle JSON content here (dispatch actions, update state, etc.)
  //       } catch (e) {
  //         // Handle the case where the response is not valid JSON
  //         store.dispatch(ShowMessageAction(msg: 'Sign-in failed. Please try again.'));
  //       }
  //     } catch (e) {
  //       // Handle other errors during sign-in
  //       store.dispatch(ShowMessageAction(msg: 'Error during sign-in: $e'));
  //     }
  //   }
  // }



  _login(AppState state) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      store.dispatch(ShowMessageAction(msg: "Form's not validated!"));
    } else {
      try {
        final response = signInMiddleware(context,
            email: state.signInState!.isPhone!
                ? state.signInState!.phoneNumber
                : state.signInState!.emailController.text,
            password: state.signInState!.passwordController.text);

        print('Response from signInMiddleware : $response');
      } catch (e) {
        store.dispatch(ShowMessageAction(msg: 'Error during sign-in: $e'));
      }
      store.dispatch(
        signInMiddleware(
          context,
          email: state.signInState!.isPhone!
              ? state.signInState!.phoneNumber
              : state.signInState!.emailController.text,
          password: state.signInState!.passwordController.text,
        ),
      );
    }
  }

  Widget forget_password(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgetPassword()),
        );
      },
      child: SizedBox(
        width: DeviceInfo(context).width,
        child: Text(
          AppLocalizations.of(context)!.login_screen_forget_password,
          style: Styles.italic_app_accent_10_underline,
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  TextFormField password_field(AppState state) {
    return TextFormField(
      controller: state.signInState!.passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        if (value.length <= 7) {
          return "Password should be 8 Characters long";
        }
        return null;
      },
      obscureText: state.signInState!.isObscure!,
      decoration: InputStyle.inputDecoratio_password(
          hint: ". . . . . . . .",
          suffixIcon: GestureDetector(
              onTap: () {
                store.dispatch(IsObscureAction());
              },
              child: Icon(state.signInState!.isObscure!
                  ? Icons.visibility_off
                  : Icons.visibility))),
    );
  }

  Widget email_or_phone(BuildContext context, AppState state) {
    return InkWell(
      onTap: () {
        store.dispatch(IsPhoneOrEmailChangeAction());
      },
      child: SizedBox(
        width: DeviceInfo(context).width,
        child: Text(
          state.signInState!.isPhone!
              ? AppLocalizations.of(context)!.common_screen_use_email
              : isOtpSystem!
                  ? AppLocalizations.of(context)!.common_screen_use_phone
                  : '',
          textAlign: TextAlign.right,
          style: Styles.italic_app_accent_10_underline,
        ),
      ),
    );
  }

  Widget email_field() {
    return TextFormField(
      controller: store.state.signInState!.emailController,
      validator: (value) {
        // Check if this field is empty
        if (value == null || value.isEmpty) {
          return 'Please enter email address';
        }

        // using regular expression
        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return "Please enter a valid email address";
        }

        // the email is valid
        return null;
      },
      decoration: InputStyle.inputDecoration_text_field(
        hint: "johndoe@example.com",
      ),
    );
  }

  Widget phone_field() {
    return SizedBox(
      child: isOtpSystem!
          ? InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                store.dispatch(
                    SetPhoneNumberAction(payload: number.phoneNumber));
              },
              countries: store.state.commonState!.countriesToString(),

              spaceBetweenSelectorAndTextField: 0,
              // textFieldController: _email,
              selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG),
              // inputBorder: InputBorder.none,
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: MyTheme.solitude,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.transparent)),

                isDense: true,
                hintText: "01XXX XXX XXX",
                hintStyle: Styles.regular_gull_grey_12,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),

                // helperText: 'Helper text',
              ),
            )
          : Const.heightShrink,
    );
  }

  Widget buildGradientContainer(BuildContext context) {
    return Container(
      height: DeviceInfo(context).height! * 0.50,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: Styles.buildLinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        children: [
          const SizedBox(
            height: 78,
          ),
          const ImageIcon(
            AssetImage('assets/logo/app_logo.png'),
            size: 93,
            color: MyTheme.white,
          ),
          Text(
            AppLocalizations.of(context)!.login_text_title,
            style: Styles.bold_white_22,
          ),
          Text(
            AppLocalizations.of(context)!.login_text_sub_title,
            style: Styles.regular_white_14,
          ),
        ],
      ),
    );
  }
}
