import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tn09_working_demo/math_function/generate_password.dart';
import 'package:tn09_working_demo/math_function/get_date_text.dart';
import 'package:tn09_working_demo/working_page/working_doing_etape_page.dart';

class SignaturePreviewWidget extends StatelessWidget {
  final Uint8List signature;
  DateTime thisDay;
  Map dataCollecteur;
  Map dataTournee;
  Map dataEtape;
  int etapeFinish;
  int etapeOK;
  int etapenotOK;
  String realStartTime;
  final CameraDescription camera;
  SignaturePreviewWidget({
    Key? key,
    required this.signature,
    required this.camera,
    required this.thisDay,
    required this.dataCollecteur,
    required this.dataTournee,
    required this.dataEtape,
    required this.etapeFinish,
    required this.etapeOK,
    required this.etapenotOK,
    required this.realStartTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: CloseButton(),
          title: Text('Store Signature'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                //Save to Galery
                final tempDir = await getTemporaryDirectory();
                String name = dataEtape['idEtape'];
                final image = await new File('${tempDir.path}/$name').create();
                image.writeAsBytesSync(signature);
                GallerySaver.saveImage(image.path);
                // Save to firestore
                String fileName =
                    getDateText(date: DateTime.now()).replaceAll('/', '_') +
                        '/' +
                        'signature/' +
                        name;
                File imagefile = File(image.path);
                await FirebaseStorage.instance
                    .ref(fileName)
                    .putFile(
                        imagefile,
                        SettableMetadata(customMetadata: {
                          'collecteur': dataCollecteur['nomCollecteur'] +
                              ' ' +
                              dataCollecteur['prenomCollecteur'],
                          'idCollecteur': dataCollecteur['idCollecteur'],
                          'date': getDateText(date: DateTime.now()),
                          'adresse': dataEtape['nomAdresseEtape'],
                        }))
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Signature Added", gravity: ToastGravity.TOP);
                });
                await FirebaseFirestore.instance
                    .collection("Etape")
                    .where('idEtape', isEqualTo: dataEtape['idEtape'])
                    .limit(1)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((doc_etape) {
                    FirebaseFirestore.instance
                        .collection("Etape")
                        .doc(doc_etape.id)
                        .update({'signature': fileName});
                  });
                });
                await FirebaseFirestore.instance
                    .collection("Etape")
                    .where('idEtape', isEqualTo: dataEtape['idEtape'])
                    .limit(1)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((doc_etape) {
                    Map<String, dynamic> next_etape =
                        doc_etape.data()! as Map<String, dynamic>;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WorkingDoingEtapePage(
                          camera: camera,
                          thisDay: thisDay,
                          dataCollecteur: dataCollecteur,
                          dataTournee: dataTournee,
                          dataEtape: next_etape,
                          etapeFinish: etapeFinish,
                          etapeOK: etapeOK,
                          etapenotOK: etapenotOK,
                          realStartTime: realStartTime,
                        ),
                      ),
                    );
                  });
                }).catchError((error) => print("Failed to add user: $error"));
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: Image.memory(signature, width: double.infinity),
        ),
      );
}
