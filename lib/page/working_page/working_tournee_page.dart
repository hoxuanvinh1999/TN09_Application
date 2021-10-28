import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tn09_app_demo/math_function/get_date_text.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/working_page/working_page.dart';

class WorkingTourneePage extends StatefulWidget {
  DateTime thisDay;
  Map dataCollecteur;
  WorkingTourneePage({
    required this.thisDay,
    required this.dataCollecteur,
  });
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
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => WorkingPage(
                                                    thisDay: widget.thisDay,
                                                  )));
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.stepBackward,
                                      size: 12,
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Working ' +
                                      getDateText(date: widget.thisDay),
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
                                  .map((DocumentSnapshot document_tournee) {
                                Map<String, dynamic> collecteur =
                                    document_tournee.data()!
                                        as Map<String, dynamic>;
                                // print('$collecteur');
                                if (collecteur['idCollecteur'] == 'null') {
                                  return SizedBox.shrink();
                                }
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  color: Colors.white,
                                  height: 80,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
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
