import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:location/location.dart';
import 'package:tn09_working_demo/math_function/get_date_text.dart';
import 'package:tn09_working_demo/math_function/get_duration.dart';
import 'package:tn09_working_demo/math_function/get_minute_duration.dart';
import 'package:tn09_working_demo/math_function/get_time_text.dart';
import 'package:tn09_working_demo/math_function/limit_length_string.dart';
import 'package:tn09_working_demo/widget/vehicule_icon.dart';
import 'package:tn09_working_demo/working_page/working_doing_etape_page.dart';
import 'package:tn09_working_demo/working_page/working_page.dart';

class WorkingEtapePage extends StatefulWidget {
  DateTime thisDay;
  Map dataCollecteur;
  Map dataTournee;
  int etapeFinish;
  int etapeOK;
  int etapenotOK;
  final CameraDescription camera;

  WorkingEtapePage({
    Key? key,
    required this.camera,
    required this.thisDay,
    required this.dataCollecteur,
    required this.dataTournee,
    required this.etapeFinish,
    required this.etapeOK,
    required this.etapenotOK,
  }) : super(key: key);
  @override
  _WorkingEtapePageState createState() => _WorkingEtapePageState();
}

class _WorkingEtapePageState extends State<WorkingEtapePage> {
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
  // For Etape
  CollectionReference _etape = FirebaseFirestore.instance.collection("Etape");
  // For Time and Duration
  String _timeString = '00:00';
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 60), (Timer t) => _getDuration());
    super.initState();
  }

  void _getDuration() {
    String result = '';
    TimeOfDay now = TimeOfDay.now();
    int hour = now.hour -
        int.parse(widget.dataTournee['realStartTime'].substring(0, 2));
    int minute = 0;
    if (now.minute -
            int.parse(widget.dataTournee['realStartTime'].substring(3, 5)) <
        0) {
      minute = now.minute -
          int.parse(widget.dataTournee['realStartTime'].substring(3, 5)) +
          60;
    } else {
      minute = now.minute -
          int.parse(widget.dataTournee['realStartTime'].substring(3, 5));
    }
    if (hour < 10) {
      result += '0';
    }
    result += hour.toString();
    result += ':';
    if (minute < 10) {
      result += '0';
    }
    result += minute.toString();
    setState(() {
      _timeString = result;
    });
  }

  // Cancel Tournee Dialog
  stopDoingDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Stop doing this Tournee?'),
            actions: [
              ElevatedButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text('Yes'),
                onPressed: () async {
                  await _etape
                      .where('idTourneeEtape',
                          isEqualTo: widget.dataTournee['idTournee'])
                      .where('status', isEqualTo: 'wait')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc_etape) {
                      _etape.doc(doc_etape.id).update({
                        'status': 'cancel',
                      });
                    });
                  });
                  await _tournee
                      .where('idTournee',
                          isEqualTo: widget.dataTournee['idTournee'])
                      .limit(1)
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc_tournee) {
                      _tournee.doc(doc_tournee.id).update({
                        'status': 'cancel',
                        'nombreEtapefinished': widget.etapeOK.toString(),
                        'nombreEtapenotfinished': widget.etapenotOK.toString(),
                        'nombreEtapeCancel':
                            (int.parse(widget.dataTournee['nombredeEtape']) -
                                    widget.etapeOK -
                                    widget.etapenotOK)
                                .toString(),
                        'realEndTime': getTimeText(time: TimeOfDay.now()),
                        'dureeMinute': getMinuteDuration(
                            time: widget.dataTournee['realStartTime']),
                        'duree': getDuration(
                            time: widget.dataTournee['realStartTime']),
                      }).then((value) async {
                        Fluttertoast.showToast(
                            msg: "Tournee Stopped", gravity: ToastGravity.TOP);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkingPage(
                                    thisDay: widget.thisDay,
                                    camera: widget.camera,
                                  )),
                        ).then((value) => setState(() {}));
                      });
                    });
                  });
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //For set up date
    DateTime nextDay = widget.thisDay.add(new Duration(days: 1));
    DateTime previousDay = widget.thisDay.subtract(Duration(days: 1));
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
                color: Colors.green,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.blue,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Icon(
                                  FontAwesomeIcons.truck,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Working',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              thickness: 5,
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.red,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        stopDoingDialog();
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.arrowAltCircleLeft,
                                        size: 15,
                                      )),
                                  Text(
                                    getDateText(date: widget.thisDay) +
                                        ' tournee ' +
                                        limitString(
                                            text:
                                                widget.dataTournee['idTournee'],
                                            limit_long: 15),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              const Divider(
                                thickness: 5,
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          )),
                      Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          color: Color(
                              int.parse(widget.dataTournee['colorTournee'])),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.user,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Collecteur: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${widget.dataCollecteur['nomCollecteur']} ${widget.dataCollecteur['prenomCollecteur']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.clock,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'StartTime: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${widget.dataTournee['realStartTime']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.hourglassStart,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Duree: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _timeString,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.building,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Etape: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.etapeFinish.toString() +
                                          '/' +
                                          widget.dataTournee['nombredeEtape'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.check,
                                      color: Colors.green,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.etapeOK.toString() +
                                          '/' +
                                          widget.dataTournee['nombredeEtape'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.times,
                                      color: Colors.black,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.etapenotOK.toString() +
                                          '/' +
                                          widget.dataTournee['nombredeEtape'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5),
                                color: Color(int.parse(
                                    widget.dataTournee['colorTournee'])),
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: _vehicule
                                      .where('idVehicule',
                                          isEqualTo:
                                              widget.dataTournee['idVehicule'])
                                      .limit(1)
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
                                    // print('$snapshot');

                                    return SingleChildScrollView(
                                      child: Row(
                                        children: snapshot.data!.docs.map(
                                            (DocumentSnapshot
                                                document_vehicule) {
                                          Map<String, dynamic> vehicule =
                                              document_vehicule.data()!
                                                  as Map<String, dynamic>;
                                          // print('$collecteur');

                                          return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: 30,
                                              color: Color(int.parse(
                                                  widget.dataTournee[
                                                      'colorTournee'])),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  buildVehiculeIcon(
                                                      icontype: vehicule[
                                                          'typeVehicule'],
                                                      iconcolor: '0xff000000',
                                                      sizeIcon: 15),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Vehicule: ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    '${vehicule['nomVehicule']}  ${vehicule['numeroImmatriculation']}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 50,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Icon(
                                  FontAwesomeIcons.building,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Etape',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        margin: EdgeInsets.only(bottom: 20),
                        height:
                            double.parse(widget.dataTournee['nombredeEtape']) *
                                300,
                        color: Colors.yellow,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _etape
                              .where('idTourneeEtape',
                                  isEqualTo: widget.dataTournee['idTournee'])
                              .orderBy('orderEtape')
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
                            // print('$snapshot');

                            return SingleChildScrollView(
                              child: Column(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document_etape) {
                                  Map<String, dynamic> etape = document_etape
                                      .data()! as Map<String, dynamic>;
                                  // print('$collecteur');

                                  return Container(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 200,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: 50,
                                            color: etape['status'] == 'finished'
                                                ? Colors.green
                                                : etape['status'] ==
                                                        'notfinished'
                                                    ? Colors.red
                                                    : Colors.grey,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.hashtag,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: 'Etape ' +
                                                              etape[
                                                                  'orderEtape'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap =
                                                                    () async {
                                                                  if (etape['status'] ==
                                                                          'finished' ||
                                                                      etape['status'] ==
                                                                          'cancel') {
                                                                    null;
                                                                  } else {
                                                                    await _etape
                                                                        .where(
                                                                            'idEtape',
                                                                            isEqualTo: etape[
                                                                                'idEtape'])
                                                                        .limit(
                                                                            1)
                                                                        .get()
                                                                        .then((QuerySnapshot
                                                                            querySnapshot) {
                                                                      querySnapshot
                                                                          .docs
                                                                          .forEach(
                                                                              (doc_etape) {
                                                                        _etape
                                                                            .doc(doc_etape.id)
                                                                            .update({
                                                                          'status':
                                                                              'doing',
                                                                          'realStartTime':
                                                                              getTimeText(time: TimeOfDay.now()),
                                                                        }).then((value) async {
                                                                          await _etape
                                                                              .where('idEtape', isEqualTo: etape['idEtape'])
                                                                              .limit(1)
                                                                              .get()
                                                                              .then((QuerySnapshot querySnapshot) {
                                                                            querySnapshot.docs.forEach((doc_etape) {
                                                                              Map<String, dynamic> next_etape = doc_etape.data()! as Map<String, dynamic>;
                                                                              print("Etape Started");
                                                                              Fluttertoast.showToast(msg: "Tournee Started", gravity: ToastGravity.TOP);

                                                                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                                                  builder: (context) => WorkingDoingEtapePage(
                                                                                        camera: widget.camera,
                                                                                        thisDay: widget.thisDay,
                                                                                        dataCollecteur: widget.dataCollecteur,
                                                                                        dataTournee: widget.dataTournee,
                                                                                        dataEtape: next_etape,
                                                                                        etapeFinish: widget.etapeFinish,
                                                                                        etapeOK: widget.etapeOK,
                                                                                        etapenotOK: widget.etapenotOK,
                                                                                        realStartTime: getTimeText(time: TimeOfDay.now()),
                                                                                      )));
                                                                            });
                                                                          }).catchError((error) => print("Failed to add user: $error"));
                                                                        });
                                                                      });
                                                                    });
                                                                  }
                                                                }),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10, bottom: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.flag,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  etape['nomAdresseEtape'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10, bottom: 10),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.mapMarker,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    etape['ligne1Adresse'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10, bottom: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.clock,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  etape['startFrequenceEtape'] +
                                                      ' - ' +
                                                      etape[
                                                          'endFrequenceEtape'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
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
                      Visibility(
                        visible: widget.etapeFinish ==
                            int.parse(widget.dataTournee['nombredeEtape']),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            margin: EdgeInsets.only(bottom: 20),
                            height: 80,
                            color: Colors.yellow,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 20, bottom: 20),
                                      child: GestureDetector(
                                        onTap: () async {
                                          await _tournee
                                              .where('idTournee',
                                                  isEqualTo: widget
                                                      .dataTournee['idTournee'])
                                              .limit(1)
                                              .get()
                                              .then((QuerySnapshot
                                                  querySnapshot) {
                                            querySnapshot.docs
                                                .forEach((doc_tournee) {
                                              _tournee
                                                  .doc(doc_tournee.id)
                                                  .update({
                                                'status': 'finished',
                                                'nombreEtapefinished':
                                                    widget.etapeOK.toString(),
                                                'nombreEtapenotfinished': widget
                                                    .etapenotOK
                                                    .toString(),
                                                'nombreEtapeCancel': '0',
                                                'realEndTime': getTimeText(
                                                    time: TimeOfDay.now()),
                                                'dureeMinute':
                                                    getMinuteDuration(
                                                        time: widget
                                                                .dataTournee[
                                                            'realStartTime']),
                                                'duree': getDuration(
                                                    time: widget.dataTournee[
                                                        'realStartTime']),
                                              }).then((value) async {
                                                Fluttertoast.showToast(
                                                    msg: "Tournee Finished",
                                                    gravity: ToastGravity.TOP);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WorkingPage(
                                                              camera:
                                                                  widget.camera,
                                                              thisDay: widget
                                                                  .thisDay)),
                                                ).then(
                                                    (value) => setState(() {}));
                                              });
                                            });
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.check,
                                              color: Colors.green,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Finish',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ])),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
