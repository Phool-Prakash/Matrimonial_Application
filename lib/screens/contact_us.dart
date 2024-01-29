import 'dart:convert';

import 'package:matrimonial_app/components/group_item.dart';
import 'package:matrimonial_app/redux/libs/contact_us/contact_us_middleware.dart';
import 'package:matrimonial_app/redux/libs/helpers/show_message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/common_app_bar.dart';
import '../components/my_gradient_container.dart';
import '../const/const.dart';
import '../const/my_theme.dart';
import '../const/style.dart';
import '../redux/app/app_state.dart';
import 'core.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool requiredFieldVerification() {
    var value =
        store.state.contactUsState!.emailController!.text.trim().toString();

    if (store.state.contactUsState!.nameController!.text
        .trim()
        .toString()
        .isEmpty) {
      store.dispatch(ShowMessageAction(msg: "Name Can't be empty"));
      return false;
    } else if (store.state.contactUsState!.emailController!.text
        .trim()
        .toString()
        .isEmpty) {
      store.dispatch(ShowMessageAction(msg: "Email Can't be empty"));

      return false;
    } else if (store.state.contactUsState!.subjectController!.text
        .trim()
        .toString()
        .isEmpty) {
      store.dispatch(ShowMessageAction(msg: "Subject Can't be empty"));

      return false;
    } else if (store.state.contactUsState!.descriptionController!.text
        .trim()
        .toString()
        .isEmpty) {
      store.dispatch(ShowMessageAction(msg: "Description Can't be empty"));

      return false;
    } else if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(value)) {
      store.dispatch(ShowMessageAction(msg: "Enter a Valid Email Address"));
      return false;
    }
    return true;
  }

  String? name, email, subject, description;
  setValues() {
    name = store.state.contactUsState!.nameController!.text.trim();
    email = store.state.contactUsState!.emailController!.text.trim();
    subject = store.state.contactUsState!.subjectController!.text.trim();
    description =
        store.state.contactUsState!.descriptionController!.text.trim();
  }

  send() async {
    if (!requiredFieldVerification()) {
      return;
    }
    await setValues();
    Map postValue = {};
    postValue.addAll({
      "name": name,
      "email": email,
      "subject": subject,
      "description": description,
    });

    var postBody = jsonEncode(postValue);
    store.dispatch(contact_us_middleware(postBody: postBody, context: context));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        appBar: CommonAppBar(text: AppLocalizations.of(context)!.contact_us)
            .build(context),
        body: buildBody(state),
      ),
    );
  }

  Widget buildBody(AppState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Const.kPaddingHorizontal, vertical: 10.0),
        child: Column(
          children: [
            Text(
              'Can we help you?',
              style: Styles.bold_storm_grey_20,
            ),
            itemSpacer(height: 20.0),
            Column(
              children: [
                GroupItem(
                    name: "Name",
                    hintText: "Enter your full name",
                    controller: state.contactUsState!.nameController),
                itemSpacer(),
                GroupItem(
                  name: "Email",
                  hintText: "Enter your E-mail",
                  helperText:
                      "Please, enter the email address where you wish to receive our answer.",
                  controller: state.contactUsState!.emailController,
                ),
                itemSpacer(height: 14.0),
                GroupItem(
                  name: 'Subject',
                  hintText: "Write the subject here",
                  controller: state.contactUsState!.subjectController,
                ),
                itemSpacer(height: 14.0),
                GroupItem(
                  name: "Description",
                  hintText: "Write your description here",
                  minLines: 6,
                  keyboardType: TextInputType.multiline,
                  controller: state.contactUsState!.descriptionController,
                ),
                itemSpacer(height: 20.0),
                buildSendBtn(state)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildSendBtn(AppState state) {
    return GestureDetector(
      onTap: send,
      child: MyGradientContainer(
        text: !state.contactUsState!.isSubmit
            ? Text(
                "Send",
                style: Styles.bold_white_14,
              )
            : CircularProgressIndicator(
                color: MyTheme.storm_grey,
              ),
      ),
    );
  }

  itemSpacer({height = 10.0}) {
    return SizedBox(height: height);
  }
}
