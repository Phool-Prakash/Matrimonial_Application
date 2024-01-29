import 'package:matrimonial_app/components/common_input.dart';
import 'package:matrimonial_app/const/my_theme.dart';
import 'package:matrimonial_app/const/style.dart';
import 'package:matrimonial_app/helpers/device_info.dart';
import 'package:matrimonial_app/main.dart';
import 'package:matrimonial_app/redux/app/app_state.dart';
import 'package:matrimonial_app/redux/libs/auth/forgetpassword_middleware.dart';
import 'package:matrimonial_app/screens/auth/signin.dart';
import 'package:matrimonial_app/screens/startup_pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();

  // controller

  TextEditingController _forgetpasswordController = TextEditingController();
  bool valueChanger = false;
  var phoneNumber;

  bool? isOtpSystem = store.state.addonState!.data!.otpSystem;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: DeviceInfo(context).height,
          child: Stack(
            children: [
              // upper section of logo, login
              Container(
                height: DeviceInfo(context).height! * 0.40,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: Styles.buildLinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
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
                      AppLocalizations.of(context)!.forget_screen_title,
                      style: Styles.bold_white_22,
                    ),
                    Text(
                      AppLocalizations.of(context)!.forget_screen_subtitle,
                      style: Styles.regular_white_14,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: DeviceInfo(context).height! * 0.65,
                  width: DeviceInfo(context).width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0))),
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
                            valueChanger ? "Phone" : "Email",
                            style: Styles.bold_app_accent_12,
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          valueChanger
                              ? SizedBox(
                                  child: isOtpSystem!
                                      ? InternationalPhoneNumberInput(
                                          onInputChanged: (PhoneNumber number) {
                                            setState(() {
                                              // print(number.phoneNumber);
                                              phoneNumber = number.phoneNumber;
                                            });
                                          },
                                          spaceBetweenSelectorAndTextField: 0,
                                          // textFieldController: _email,
                                          selectorConfig: SelectorConfig(
                                              selectorType:
                                                  PhoneInputSelectorType
                                                      .DIALOG),
                                          // inputBorder: InputBorder.none,
                                          inputDecoration: InputStyle
                                              .inputDecoration_text_field(
                                            hint: "01XXX XXX XXX",
                                          ),
                                        )
                                      : SizedBox(),
                                )
                              : TextFormField(
                                  controller: _forgetpasswordController,
                                  validator: (value) {
                                    // Check if this field is empty
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter email address';
                                    }

                                    // using regular expression
                                    if (!RegExp(r'\S+@\S+\.\S+')
                                        .hasMatch(value)) {
                                      return "Please enter a valid email address";
                                    }

                                    // the email is valid
                                    return null;
                                  },
                                  decoration:
                                      InputStyle.inputDecoration_text_field(
                                    hint: "johndoe@example.com",
                                  ),
                                ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Container(
                          //   width: DeviceInfo(context).width,
                          //   child: Text(
                          //     AppLocalizations.of(context)
                          //         .login_screen_email_helper_text,
                          //     style: TextStyle(
                          //         fontSize: 10, color: MyTheme.gull_grey),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),

                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                valueChanger = !valueChanger;
                              });
                            },
                            child: SizedBox(
                              width: DeviceInfo(context).width,
                              child: Text(
                                valueChanger
                                    ? AppLocalizations.of(context)!
                                        .common_screen_use_email
                                    : isOtpSystem!
                                        ? AppLocalizations.of(context)!
                                            .common_screen_use_phone
                                        : '',
                                textAlign: TextAlign.right,
                                style: Styles.italic_app_accent_10_underline,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                          ),
                          sendCode(context, state),
                          SizedBox(
                            height: 30,
                          ),

                          /// or back to login

                          buildbacktologinContainer(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell sendCode(BuildContext context, AppState state) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (!_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("Form's not validated")),
          );
        } else {
          var send_by = valueChanger ? "phone" : "email";
          var email =
              valueChanger ? phoneNumber : _forgetpasswordController.text;

          store.dispatch(forgetPasswordMiddleware(
            context: context,
            send_by: send_by,
            email: email,
          ));

          prefs.setString('reset_send_by', send_by);
          prefs.setString('reset_email', email);
        }

        _forgetpasswordController.clear();
      },
      child: Container(
        height: 50,
        width: DeviceInfo(context).width,
        child: Center(
          child: state.forgetPasswordState!.fp_loader == false
              ? Text(
                  AppLocalizations.of(context)!.forget_screen_send_code,
                  style: Styles.bold_white_14,
                )
              : CircularProgressIndicator(
                  color: MyTheme.storm_grey,
                ),
        ),
        decoration: BoxDecoration(
          gradient: Styles.buildLinearGradient(
              begin: Alignment.centerLeft, end: Alignment.centerRight),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    );
  }

  Container buildbacktologinContainer(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.forget_screen_or_back_to,
                style: Styles.regular_gull_grey_12,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text(
                  ' ' + AppLocalizations.of(context)!.forget_screen_login,
                  style: Styles.bold_app_accent_12,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
