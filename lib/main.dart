import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:moodiboom/controllers/authorization_controller.dart';
import 'package:moodiboom/controllers/connection_controller.dart';
import 'package:moodiboom/controllers/counter_controller.dart';
import 'package:moodiboom/controllers/details_info_controller.dart';
import 'package:moodiboom/pages/main_page.dart';
import 'package:moodiboom/pages/splash_page.dart';
import 'package:moodiboom/utils/constants.dart';

void main() {
  runApp(Phoenix(
    child: MultiBlocProvider(providers: [
      BlocProvider<AuthorizationController>(
          create: (context) => AuthorizationController()),
      BlocProvider<ConnectionController>(
          create: ((context) => ConnectionController())),
      BlocProvider<DetailsInfoController>(
          create: ((context) => DetailsInfoController())),
      BlocProvider<CounterController>(
          create: ((context) => CounterController())),
    ], child: App()),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
                builder: (context, widget) {
                  return MultiBlocListener(listeners: [
                    BlocListener<AuthorizationController, AuthorizationStates>(
                        listener: (context, state) {}),
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
                });
  }
}
