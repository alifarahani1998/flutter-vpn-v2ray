import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodiboom/utils/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class VersionStates {}

class VersionStateInitial extends VersionStates {}

class VersionStateNewVersionAvailable extends VersionStates {
  VersionStateNewVersionAvailable();
}

class VersionStatePassVersionChecking extends VersionStates {}

class VersionController extends Cubit<VersionStates> {
  VersionController() : super(VersionStateInitial()) {
    checkNewVersion();
  }

  Future<void> checkNewVersion() async {
    var client = HttpClient();

    var request = await client.getUrl(Uri.parse(appVersionURL));

    var response = await request.close();

    if (response.statusCode == 200) {
      var newestAppVersion = await response.transform(utf8.decoder).join();
      if (newestAppVersion.contains('\n'))
        newestAppVersion = newestAppVersion.split('\n')[0];

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentAppVersion = packageInfo.version;

      client.close();

      newestAppVersion != currentAppVersion
          ? emit(VersionStateNewVersionAvailable())
          : emit(VersionStatePassVersionChecking());
    } else {
      emit(VersionStatePassVersionChecking());
    }
  }
}
