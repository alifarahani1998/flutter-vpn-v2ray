import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

enum QRCodeScanPageStates { initial, loaded, unloaded }

class QRCodeScanPageController extends Cubit<QRCodeScanPageStates> {
  QRCodeScanPageController() : super(QRCodeScanPageStates.initial) {
    checkCameraPermission();
  }

  late PermissionStatus cameraPermission;

  Future<void> checkCameraPermission() async {
    cameraPermission = await Permission.camera.status;
    switch (cameraPermission) {
      case PermissionStatus.granted:
        emit(QRCodeScanPageStates.loaded);
        break;
      case PermissionStatus.denied:
        await getCamerasPermission();
        break;
      case PermissionStatus.permanentlyDenied:
        emit(QRCodeScanPageStates.unloaded);
        await openAppSettings();
        break;
      case PermissionStatus.restricted:
        emit(QRCodeScanPageStates.unloaded);
        break;
      case PermissionStatus.limited:
        emit(QRCodeScanPageStates.unloaded);
        break;
      default:
        break;
    }
  }

  Future<void> getCamerasPermission() async {
    switch (await Permission.camera.request()) {
      case PermissionStatus.granted:
        cameraPermission = PermissionStatus.granted;
        emit(QRCodeScanPageStates.loaded);
        break;
      case PermissionStatus.denied:
        cameraPermission = PermissionStatus.denied;
        emit(QRCodeScanPageStates.unloaded);
        break;
      case PermissionStatus.permanentlyDenied:
        cameraPermission = PermissionStatus.permanentlyDenied;
        emit(QRCodeScanPageStates.unloaded);
        break;
      case PermissionStatus.restricted:
        cameraPermission = PermissionStatus.permanentlyDenied;
        emit(QRCodeScanPageStates.unloaded);
        break;
      case PermissionStatus.limited:
        cameraPermission = PermissionStatus.permanentlyDenied;
        emit(QRCodeScanPageStates.unloaded);
        break;
      default:
        break;
    }
  }
}
