import 'package:flutter/material.dart';
import 'package:moodiboom/utils/constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  Future<void> waitForSplash(BuildContext context) => Future.delayed(const Duration(seconds: 2),
        () => Navigator.pushReplacementNamed(context, MAIN_PAGE));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: waitForSplash(context),
        builder: (context, _) => Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: blackColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    maskUpRight,
                    color: baseColor,
                  ),
                ),
                Text(
                  moodiboom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: baseColor,
                      fontFamily: 'Gilroy-Heavy',
                      fontSize: 48,
                      fontWeight: FontWeight.w900),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    maskDownLeft,
                    color: baseColor,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
