import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tn09_app_demo/math_function/generate_password.dart';

class SignaturePreviewPage extends StatelessWidget {
  final Uint8List signature;

  const SignaturePreviewPage({
    Key? key,
    required this.signature,
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
                String name = generatePassword() + '.jpg';
                final image = await new File('${tempDir.path}/$name').create();
                image.writeAsBytesSync(signature);
                GallerySaver.saveImage(image.path);
                // Save to firestore
                String fileName = basename(image.path);
                File imagefile = File(image.path);
                await FirebaseStorage.instance
                    .ref(fileName)
                    .putFile(
                        imagefile,
                        SettableMetadata(customMetadata: {
                          'uploaded_by': 'Tester',
                          'description': 'Testing firestorage'
                        }))
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Photo Added", gravity: ToastGravity.TOP);
                });
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
