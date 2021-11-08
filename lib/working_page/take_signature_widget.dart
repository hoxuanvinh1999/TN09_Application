import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signature/signature.dart';
import 'package:tn09_working_demo/working_page/signature_preview_widget.dart';

class TakeSignatureWidget extends StatefulWidget {
  DateTime thisDay;
  Map dataCollecteur;
  Map dataTournee;
  Map dataEtape;
  int etapeFinish;
  int etapeOK;
  int etapenotOK;
  String realStartTime;
  List<String> typeContenant;
  final CameraDescription camera;
  TakeSignatureWidget({
    Key? key,
    required this.camera,
    required this.thisDay,
    required this.dataCollecteur,
    required this.dataTournee,
    required this.dataEtape,
    required this.etapeFinish,
    required this.etapeOK,
    required this.etapenotOK,
    required this.realStartTime,
    required this.typeContenant,
  }) : super(key: key);
  @override
  _TakeSignatureWidgetState createState() => _TakeSignatureWidgetState();
}

class _TakeSignatureWidgetState extends State<TakeSignatureWidget> {
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
      body: Column(
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
                        final signature = await exportController.toPngBytes();
                        if (signature != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignaturePreviewWidget(
                                camera: widget.camera,
                                thisDay: widget.thisDay,
                                dataCollecteur: widget.dataCollecteur,
                                dataTournee: widget.dataTournee,
                                dataEtape: widget.dataEtape,
                                etapeFinish: widget.etapeFinish,
                                etapeOK: widget.etapeOK,
                                etapenotOK: widget.etapenotOK,
                                realStartTime: widget.realStartTime,
                                signature: signature,
                                typeContenant: widget.typeContenant,
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
    );
  }
}
