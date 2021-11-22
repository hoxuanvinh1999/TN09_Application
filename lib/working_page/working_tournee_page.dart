import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tn09_working_demo/math_function/get_date_text.dart';
import 'package:tn09_working_demo/math_function/get_time_text.dart';
import 'package:tn09_working_demo/widget/vehicule_icon.dart';
import 'package:tn09_working_demo/working_page/working_etape_page.dart';
import 'package:tn09_working_demo/working_page/working_page.dart';
import 'package:tn09_working_demo/decoration/graphique.dart' as graphique;

class WorkingTourneePage extends StatefulWidget {
  DateTime thisDay;
  Map dataCollecteur;
  final CameraDescription camera;

  WorkingTourneePage({
    Key? key,
    required this.camera,
    required this.dataCollecteur,
    required this.thisDay,
  }) : super(key: key);
  @override
  _WorkingTourneePageState createState() => _WorkingTourneePageState();
}

class _WorkingTourneePageState extends State<WorkingTourneePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //For Collecteur
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference _collecteur =
      FirebaseFirestore.instance.collection("Collecteur");

  DateTime date = DateTime.now();

  // String getText() {
  //   if (date == null) {
  //     return 'Select Date';
  //   } else {
  //     return DateFormat('MM/dd/yyyy').format(date);
  //     // return '${date.month}/${date.day}/${date.year}';
  //   }
  // }

  // For Tournee
  CollectionReference _tournee =
      FirebaseFirestore.instance.collection("Tournee");
  // For Vehicule
  CollectionReference _vehicule =
      FirebaseFirestore.instance.collection("Vehicule");
  @override
  Widget build(BuildContext context) {
    //For set up date
    // DateTime nextDay = widget.thisDay.add(new Duration(days: 1));
    // DateTime previousDay = widget.thisDay.subtract(Duration(days: 1));
    // inputData();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //     color: Colors.yellow,
            //     width: double.infinity,
            //     height: 40,
            //     child: Row(
            //       children: [
            //         SizedBox(
            //           width: 40,
            //         ),
            //         Icon(
            //           FontAwesomeIcons.home,
            //           size: 12,
            //         ),
            //         SizedBox(width: 5),
            //         RichText(
            //           text: TextSpan(
            //             children: <TextSpan>[
            //               TextSpan(
            //                   text: 'Home',
            //                   style: TextStyle(
            //                       color: Colors.red,
            //                       fontSize: 15,
            //                       fontWeight: FontWeight.bold),
            //                   recognizer: TapGestureRecognizer()
            //                     ..onTap = () {
            //                       Navigator.of(context).pushReplacement(
            //                           MaterialPageRoute(
            //                               builder: (context) => HomeScreen()));
            //                     }),
            //             ],
            //           ),
            //         ),
            //         SizedBox(
            //           width: 10,
            //         ),
            //         Icon(
            //           FontAwesomeIcons.chevronCircleRight,
            //           size: 12,
            //         ),
            //         SizedBox(
            //           width: 10,
            //         ),
            //         RichText(
            //           text: TextSpan(
            //             children: <TextSpan>[
            //               TextSpan(
            //                 text: 'Collecteur',
            //                 style: TextStyle(
            //                     color: Colors.grey,
            //                     fontSize: 15,
            //                     fontWeight: FontWeight.bold),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     )),
            // SizedBox(height: 20),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Color(graphique.color['special_bureautique_2']),
                  border: Border.all(
                      width: 1.0,
                      color: Color(graphique.color['default_black'])),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Color(graphique.color['main_color_1']),
                        border: Border.all(
                            width: 1.0,
                            color: Color(graphique.color['default_black'])),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Icon(
                            FontAwesomeIcons.truck,
                            color: Color(graphique.color['main_color_2']),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Working',
                            style: TextStyle(
                              color: Color(graphique.color['main_color_2']),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(graphique.color['main_color_1']),
                        border: Border.all(
                            width: 1.0,
                            color: Color(graphique.color['default_black'])),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => WorkingPage(
                                              thisDay: widget.thisDay,
                                              camera: widget.camera,
                                            )));
                              },
                              icon: Icon(
                                FontAwesomeIcons.stepBackward,
                                size: 12,
                                color: Color(graphique.color['main_color_2']),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Working ' + getDateText(date: widget.thisDay),
                            style: TextStyle(
                              color: Color(graphique.color['main_color_2']),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        color: Colors.grey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Select Tournee for ${widget.dataCollecteur['nomCollecteur']} ${widget.dataCollecteur['prenomCollecteur']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _tournee
                            .where('dateTournee',
                                isEqualTo: getDateText(date: widget.thisDay))
                            .where('status', isEqualTo: 'wait')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('${snapshot.error.toString()}');
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document_tournee) {
                                Map<String, dynamic> tournee = document_tournee
                                    .data()! as Map<String, dynamic>;
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  color: Colors.white,
                                  height: 150,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: 30,
                                        color: Color(
                                            int.parse(tournee['colorTournee'])),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            'Tournee ${tournee['idTournee']}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                await _tournee
                                                                    .where(
                                                                        'idTournee',
                                                                        isEqualTo:
                                                                            tournee[
                                                                                'idTournee'])
                                                                    .limit(1)
                                                                    .get()
                                                                    .then((QuerySnapshot
                                                                        querySnapshot) {
                                                                  querySnapshot
                                                                      .docs
                                                                      .forEach(
                                                                          (doc_tournee) {
                                                                    _tournee
                                                                        .doc(doc_tournee
                                                                            .id)
                                                                        .update({
                                                                      'status':
                                                                          'doing',
                                                                      'realStartTime':
                                                                          getTimeText(
                                                                              time: TimeOfDay.now()),
                                                                      'idCollecteur':
                                                                          widget
                                                                              .dataCollecteur['idCollecteur']
                                                                    }).then((value) async {
                                                                      await _tournee
                                                                          .where(
                                                                              'idTournee',
                                                                              isEqualTo: tournee[
                                                                                  'idTournee'])
                                                                          .limit(
                                                                              1)
                                                                          .get()
                                                                          .then((QuerySnapshot
                                                                              querySnapshot) {
                                                                        querySnapshot
                                                                            .docs
                                                                            .forEach((doc_tournee) {
                                                                          Map<String, dynamic>
                                                                              next_tournee =
                                                                              doc_tournee.data()! as Map<String, dynamic>;
                                                                          print(
                                                                              "Tournee Started");
                                                                          Fluttertoast.showToast(
                                                                              msg: "Tournee Started",
                                                                              gravity: ToastGravity.TOP);

                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => WorkingEtapePage(
                                                                                      camera: widget.camera,
                                                                                      thisDay: widget.thisDay,
                                                                                      dataCollecteur: widget.dataCollecteur,
                                                                                      dataTournee: next_tournee,
                                                                                      etapeFinish: 0,
                                                                                      etapeOK: 0,
                                                                                      etapenotOK: 0,
                                                                                    )),
                                                                          ).then((value) =>
                                                                              setState(() {}));
                                                                        });
                                                                      }).catchError((error) =>
                                                                              print("Failed to add user: $error"));
                                                                    });
                                                                  });
                                                                });
                                                              }),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                FontAwesomeIcons.building,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Etape: ${tournee['nombredeEtape']}',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                FontAwesomeIcons.clock,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Start: ${tournee['startTime']}',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ]),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: _vehicule
                                              .where('idVehicule',
                                                  isEqualTo:
                                                      tournee['idVehicule'])
                                              .limit(1)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              print(
                                                  '${snapshot.error.toString()}');
                                              return Text(
                                                  'Something went wrong');
                                            }

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }
                                            // print('$snapshot');

                                            return SingleChildScrollView(
                                              child: Row(
                                                children: snapshot.data!.docs
                                                    .map((DocumentSnapshot
                                                        document_vehicule) {
                                                  Map<String, dynamic>
                                                      vehicule =
                                                      document_vehicule.data()!
                                                          as Map<String,
                                                              dynamic>;
                                                  // print('$collecteur');

                                                  return Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height: 30,
                                                      color: Colors.white,
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          buildVehiculeIcon(
                                                              icontype: vehicule[
                                                                  'typeVehicule'],
                                                              iconcolor: vehicule[
                                                                      'colorIconVehicule']
                                                                  .toUpperCase(),
                                                              sizeIcon: 15),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            '${vehicule['nomVehicule']}  ${vehicule['numeroImmatriculation']}',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                                }).toList(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
