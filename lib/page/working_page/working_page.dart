import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tn09_app_demo/math_function/get_date_text.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';

class WorkingPage extends StatefulWidget {
  DateTime thisDay;
  WorkingPage({
    required this.thisDay,
  });
  @override
  _WorkingPageState createState() => _WorkingPageState();
}

class _WorkingPageState extends State<WorkingPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _createCollecteurKeyForm = GlobalKey<FormState>();
  final _modifyCollecteurKeyForm = GlobalKey<FormState>();
  String _siteCollecteur = 'Bordeaux';
  List<String> list_site = ['Bordeaux', 'Paris', 'Lille'];
  TextEditingController _nomCollecteurController = TextEditingController();
  TextEditingController _prenomCollecteurController = TextEditingController();
  TextEditingController _nomModifyCollecteurController =
      TextEditingController();
  TextEditingController _prenomModifyCollecteurController =
      TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference _collecteur =
      FirebaseFirestore.instance.collection("Collecteur");
  Stream<QuerySnapshot> _collecteurStream = FirebaseFirestore.instance
      .collection("Collecteur")
      .orderBy('nomCollecteur')
      .snapshots();

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
                width: double.infinity,
                height: 800,
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
                        color: Colors.red,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 40,
                                  color: Colors.yellow,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WorkingPage(
                                                              thisDay:
                                                                  previousDay,
                                                            )));
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.stepBackward,
                                            size: 12,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            pickDate(context);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.calendar,
                                            size: 12,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WorkingPage(
                                                              thisDay: nextDay,
                                                            )));
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.stepForward,
                                            size: 12,
                                          ))
                                    ],
                                  ),
                                ),
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
                    Container(),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
