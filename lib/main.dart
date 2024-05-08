import 'package:flutter/material.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:smartech_base/smartech_base.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'routes.dart';
import 'theme.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
  deeplinkHandle();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Way - Template',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}

void deeplinkHandle(){
      Smartech().onHandleDeeplink((String? smtDeeplinkSource, String? smtDeeplink, Map<dynamic, dynamic>? smtPayload, Map<dynamic, dynamic>? smtCustomPayload) async {
  if (smtDeeplink != null){
    //smartech://myPage/page } value of smtDeeplink
   await launchUrlString(smtDeeplink);
  print(smtDeeplink);
  }
});
}