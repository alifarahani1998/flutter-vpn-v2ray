import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                SvgPicture.asset(logoText),
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
