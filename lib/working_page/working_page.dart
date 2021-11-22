import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tn09_working_demo/math_function/get_date_text.dart';
import 'package:tn09_working_demo/working_page/working_tournee_page.dart';
import 'package:tn09_working_demo/decoration/graphique.dart' as graphique;

class WorkingPage extends StatefulWidget {
  DateTime thisDay;
  final CameraDescription camera;

  WorkingPage({
    Key? key,
    required this.camera,
    required this.thisDay,
  }) : super(key: key);
  @override
  _WorkingPageState createState() => _WorkingPageState();
}

class _WorkingPageState extends State<WorkingPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  // For Collecteur
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

  // Pick Date widget
  Future pickDate(BuildContext context) async {
    final initialDate = widget.thisDay;
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 25),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) return;

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => WorkingPage(
              thisDay: newDate,
              camera: widget.camera,
            )));
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
            //     color: Color(graphique.color['default_yellow']),
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
                          Container(
                            width: 150,
                            height: 40,
                            color: Color(graphique.color['default_yellow']),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => WorkingPage(
                                                    thisDay: previousDay,
                                                    camera: widget.camera,
                                                  )));
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.stepBackward,
                                      color: Color(
                                          graphique.color['default_black']),
                                      size: 12,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      pickDate(context);
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.calendar,
                                      color: Color(
                                          graphique.color['default_black']),
                                      size: 12,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => WorkingPage(
                                                    thisDay: nextDay,
                                                    camera: widget.camera,
                                                  )));
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.stepForward,
                                      size: 12,
                                      color: Color(
                                          graphique.color['default_black']),
                                    ))
                              ],
                            ),
                          ),
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
                                  'Select Collecteur ',
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
                        stream: _collecteur
                            .where('idCollecteur', isNotEqualTo: 'null')
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document_collecteur) {
                                Map<String, dynamic> collecteur =
                                    document_collecteur.data()!
                                        as Map<String, dynamic>;
                                // print('$collecteur');
                                if (collecteur['idCollecteur'] == 'null') {
                                  return SizedBox.shrink();
                                }
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  alignment: Alignment(-0.8, 0),
                                  color:
                                      Color(graphique.color['default_white']),
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: collecteur['nomCollecteur'] +
                                                ' ' +
                                                collecteur['prenomCollecteur'],
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                WorkingTourneePage(
                                                                  camera: widget
                                                                      .camera,
                                                                  thisDay: widget
                                                                      .thisDay,
                                                                  dataCollecteur:
                                                                      collecteur,
                                                                )));
                                              }),
                                      ],
                                    ),
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
