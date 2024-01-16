import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodiboom/controllers/qr_scanner_page_controller.dart';
import 'package:moodiboom/utils/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  QRCodeScannerPage();

  @override
  State<QRCodeScannerPage> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  late final QRViewController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QRCodeScanPageController>(
      create: (context) => QRCodeScanPageController(),
      child: BlocConsumer<QRCodeScanPageController, QRCodeScanPageStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: blackColor,
              body: state == QRCodeScanPageStates.loaded
                  ? Container(
                      alignment: Alignment.center,
                      color: blackColor,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(40.0.r)),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  QRView(
                                    overlay: QrScannerOverlayShape(
                                      borderWidth: 0.001,
                                      borderRadius: 60.r,
                                      cutOutSize: 0.75.sw,
                                    ),
                                    key: GlobalKey(debugLabel: 'QR'),
                                    onQRViewCreated: (controller) {
                                      if (state ==
                                          QRCodeScanPageStates.loaded) {
                                        this.controller = controller;
                                      }
                                      bool scanned = false;
                                      controller.scannedDataStream
                                          .listen((barcode) {
                                        controller.pauseCamera();
                                        if (!scanned) {
                                          scanned = true;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container());
        },
      ),
    );
  }
}
