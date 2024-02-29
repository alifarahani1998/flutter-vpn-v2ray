import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodiboom/controllers/version_controller.dart';
import 'package:moodiboom/utils/constants.dart';
import 'package:moodiboom/widgets/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  updateApp() async => await launchUrl(Uri.parse(appDownloadURL));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VersionController>(
      create: (context) => VersionController(),
      child: BlocConsumer<VersionController, VersionStates>(
        listener: (context, state) async {
          if (state is VersionStateNewVersionAvailable) {
            await showDialog(
                context: context,
                builder: (context) => warningDialog(
                    context,
                    'A newer version of the app is available. Do you want to update?',
                    'Yes',
                    'No')).then((value) => value ? updateApp() : null);
            Navigator.pushReplacementNamed(context, MAIN_PAGE);
          } else if (state is VersionStatePassVersionChecking)
            Navigator.pushReplacementNamed(context, MAIN_PAGE);
        },
        builder: (context, state) {
          return Scaffold(
              body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: blackColor,
                  child: Stack(
                    alignment: Alignment.center,
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
                  )));
        },
      ),
    );
  }
}
