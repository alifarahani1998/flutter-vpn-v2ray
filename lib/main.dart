import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:moodiboom/controllers/authorization_controller.dart';
import 'package:moodiboom/controllers/connection_controller.dart';
import 'package:moodiboom/helpers/global.dart';
import 'package:moodiboom/pages/main_page.dart';
import 'package:moodiboom/pages/qr_scanner_page.dart';
import 'package:moodiboom/pages/splash_page.dart';
import 'package:moodiboom/utils/constants.dart';
// import 'package:snapping_sheet/snapping_sheet.dart';

void main() {
  runApp(Phoenix(
    child: MultiBlocProvider(providers: [
      BlocProvider<AuthorizationController>(
          create: (context) => AuthorizationController()),
      BlocProvider<ConnectionController>(
          create: ((context) => ConnectionController())),
    ], child: App()),
  ));
  // runApp(SnappingSheetExampleApp());
}

class App extends StatelessWidget {
  Future<void> logout() async {
    await Global.shPreferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, widget) {
          return MultiBlocListener(listeners: [
            BlocListener<AuthorizationController, AuthorizationStates>(
                listener: (context, state) {
              // if (state is AuthorizationStatesUnauthorizedAndSignedOut) {
              //   logout();
              //   Phoenix.rebirth(context);
              // }
            }),
          ], child: widget!);
        },
        title: "VPN",
        theme: ThemeData(
            fontFamily: "Gilroy-Regular",
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        initialRoute: SPLASH_PAGE,
        routes: {
          SPLASH_PAGE: (context) => SplashPage(),
          MAIN_PAGE: (context) => MainPage(),
          QR_SCANNER_PAGE: (context) => QRCodeScannerPage(),
        });
  }
}
