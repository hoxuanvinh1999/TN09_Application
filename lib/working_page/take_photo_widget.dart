import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:tn09_working_demo/math_function/get_date_text.dart';
import 'package:tn09_working_demo/working_page/working_doing_etape_page.dart';
import 'package:tn09_working_demo/decoration/graphique.dart' as graphique;

class TakePhotoWidget extends StatefulWidget {
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
  TakePhotoWidget({
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
  _TakePhotoWidgetState createState() => _TakePhotoWidgetState();
}

class _TakePhotoWidgetState extends State<TakePhotoWidget> {
  // For Etape
  CollectionReference _etape = FirebaseFirestore.instance.collection("Etape");

  // For Camera
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //For set up date
    DateTime nextDay = widget.thisDay.add(new Duration(days: 1));
    DateTime previousDay = widget.thisDay.subtract(Duration(days: 1));
    // inputData();
    return Scaffold(
      body: Column(children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 50,
            color: Colors.blue,
            alignment: Alignment(0, 0),
            width: MediaQuery.of(context).size.width * 0.95,
            child: GestureDetector(
              onTap: () async {
                try {
                  await _initializeControllerFuture;

                  final image = await _controller.takePicture();
                  print('image path: ${image.path}');
                  //Save Image to Galery
                  GallerySaver.saveImage(image.path);
                  //Save to firestore
                  String fileName =
                      getDateText(date: DateTime.now()).replaceAll('/', '_') +
                          '/' +
                          'image/' +
                          widget.dataEtape['idEtape'];
                  File imagefile = File(image.path);
                  await FirebaseStorage.instance.ref(fileName).putFile(
                      imagefile,
                      SettableMetadata(customMetadata: {
                        'collecteur': widget.dataCollecteur['nomCollecteur'] +
                            ' ' +
                            widget.dataCollecteur['prenomCollecteur'],
                        'idCollecteur': widget.dataCollecteur['idCollecteur'],
                        'date': getDateText(date: DateTime.now()),
                        'adresse': widget.dataEtape['nomAdresseEtape'],
                      }));
                  await _etape
                      .where('idEtape', isEqualTo: widget.dataEtape['idEtape'])
                      .limit(1)
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc_etape) {
                      _etape.doc(doc_etape.id).update({'image': fileName});
                    });
                  });
                  await _etape
                      .where('idEtape', isEqualTo: widget.dataEtape['idEtape'])
                      .limit(1)
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc_etape) {
                      Map<String, dynamic> next_etape =
                          doc_etape.data()! as Map<String, dynamic>;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WorkingDoingEtapePage(
                              camera: widget.camera,
                              thisDay: widget.thisDay,
                              dataCollecteur: widget.dataCollecteur,
                              dataTournee: widget.dataTournee,
                              dataEtape: next_etape,
                              etapeFinish: widget.etapeFinish,
                              etapeOK: widget.etapeOK,
                              etapenotOK: widget.etapenotOK,
                              realStartTime: widget.realStartTime,
                              typeContenant: widget.typeContenant),
                        ),
                      );
                    });
                  }).catchError((error) => print("Failed to add user: $error"));
                } catch (e) {
                  print(e);
                }
              },
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.camera,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Take Photo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
      ]),
    );
  }
}
