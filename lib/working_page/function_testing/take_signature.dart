import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signature/signature.dart';
import 'package:tn09_working_demo/working_page/function_testing/signature_preview_page.dart';

class TakeSignatureScreen extends StatefulWidget {
  @override
  _TakeSignatureScreenState createState() => _TakeSignatureScreenState();
}

class _TakeSignatureScreenState extends State<TakeSignatureScreen> {
  @override
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Take Signature')),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                color: Colors.blue,
                child: Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.black,
                  height: 500,
                  // width: MediaQuery.of(context).size.width * 0.95,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          if (_signatureController.isNotEmpty) {
                            final exportController = SignatureController(
                              penStrokeWidth: 2,
                              penColor: Colors.black,
                              exportBackgroundColor: Colors.white,
                              points: _signatureController.points,
                            );
                            final signature =
                                await exportController.toPngBytes();
                            if (signature != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignaturePreviewPage(
                                    signature: signature,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        icon: Icon(
                          FontAwesomeIcons.check,
                          size: 20,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: () {
                          _signatureController.clear();
                        },
                        icon: Icon(
                          FontAwesomeIcons.times,
                          size: 20,
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
