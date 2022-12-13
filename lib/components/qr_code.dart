import 'dart:io';

import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
    Barcode result;
    QRViewController controller;
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    // In order to get hot reload to work we need to pause the camera if the platform
    // is android, or resume the camera if the platform is iOS.
    @override
    void reassemble() {
        super.reassemble();
        if (Platform.isAndroid) {
            controller.pauseCamera();
        }
        controller.resumeCamera();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: SafeArea(
              child: Column(
                  children: <Widget>[
                      Container(
                          color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                          child: Column(
                              children: [
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height * (1.2 / 100),
                                  ),
                                  Row(
                                      children: [
                                          SizedBox(
                                              width: MediaQuery.of(context).size.height * (1.2 / 100),
                                          ),
                                          Container(
                                              height: MediaQuery.of(context).size.height * (5.91 / 100),
                                              child: IconButton(
                                                  icon: Icon(Icons.arrow_back_ios,
                                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                                                  ),
                                                  onPressed: () {
                                                      Navigator.pop(context);
                                                  },
                                              ),
                                          ),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                                      tr(LocalKeys.scan),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                                                      ),
                                                  ),
                                              ),
                                          ),
                                          Container(
                                              width: MediaQuery.of(context).size.height * (5.91 / 100),
                                          )
                                      ],
                                  ),
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height * (1.97 / 100),
                                  ),
                              ],
                          ),
                      ),
                      Expanded(flex: 4, child: _buildQrView(context)),
                  ],
              ),
            ),
        );
    }

    Widget _buildQrView(BuildContext context) {
        // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
        var scanArea = (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
                ? 150.0
                : 300.0;
        // To ensure the Scanner view is properly sizes after rotation
        // we need to listen for Flutter SizeChanged notification and update controller
        return QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: scanArea),
        );
    }

    void _onQRViewCreated(QRViewController controller) {
        setState(() {
            this.controller = controller;
        });
        controller.scannedDataStream.listen((scanData) {
            setState(() {
                result = scanData;
                controller.pauseCamera();
                print('dddddddd');
                print(scanData.code);
                Navigator.pop(context,scanData.code);
            });
        });
    }

    @override
    void dispose() {
        controller?.dispose();
        super.dispose();
    }
}