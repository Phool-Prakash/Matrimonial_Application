import 'dart:convert';

import 'package:matrimonial_app/app_config.dart';
import 'package:matrimonial_app/components/common_app_bar.dart';
import 'package:matrimonial_app/helpers/navigator_push.dart';
import 'package:matrimonial_app/screens/my_dashboard_pages/my_wallet.dart';
import 'package:matrimonial_app/screens/package/package_history.dart';
import 'package:matrimonial_app/screens/startup_pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_context/one_context.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../const/const.dart';
import '../../main.dart';
import '../../redux/libs/account/account_middleware.dart';
import '../../redux/libs/helpers/show_message_state.dart';

class StripeScreen extends StatefulWidget {
  var amount;
  String? payment_type;
  String? payment_method_key;
  String? package_id;

  StripeScreen(
      {Key? key,
      this.amount,
      this.payment_type,
      this.payment_method_key,
      this.package_id})
      : super(key: key);

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  String? initialUrl;
  WebViewController _webViewController = WebViewController();

  String? accessToken = prefs.getString(Const.accessToken);
  var userId = store.state.authState!.userData!.id!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialUrl =
        "${AppConfig.BASE_URL}/stripe?amount=${widget.amount}&payment_method=${widget.payment_method_key}&payment_type=${widget.payment_type}&package_id=${widget.package_id}&user_id=$userId";

    stripe();
  }

  stripe() {
    print(initialUrl);
    print("Bearer $accessToken");

    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {},
          onPageFinished: (page) {
            if (page.contains("/stripe/success")) {
              getData();
            } else if (page.contains("/stripe/cancel")) {
              Navigator.of(context).pop();
              return;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl!), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken"
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBar(text: AppLocalizations.of(context)!.stripe_screen_title)
              .build(context),
      body: buildBody(),
    );
  }

  void getData() {
    _webViewController
        .runJavaScriptReturningResult("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data as String);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      //print(data.toString());
      if (responseJSON["result"] == false) {
        store.dispatch(ShowMessageAction(
          msg: responseJSON["message"],
        ));

        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        store.dispatch(ShowMessageAction(
          msg: responseJSON["message"],
        ));

        if (widget.payment_type == "wallet_payment") {
          NavigatorPush.push_remove_untill(
            page: MyWallet(
              from_wallet: true,
            ),
          );
          OneContext().navigator.push(
                MaterialPageRoute(
                  builder: (context) => MyWallet(
                    from_wallet: true,
                  ),
                ),
              );
        } else if (widget.payment_type == "package_payment") {
          store.dispatch(accountMiddleware());

          OneContext().navigator.push(
                MaterialPageRoute(
                  builder: (context) => PackageHistory(
                    from_package: true,
                  ),
                ),
              );
        }
      }
    });
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:
              // initialUrl != null
              //     ?
              WebViewWidget(
            controller: _webViewController,
          )
          // : const Center(child: Text("loading...")),
          ),
    );
  }
}
