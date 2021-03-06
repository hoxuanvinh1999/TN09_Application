import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tn09_working_demo/math_function/get_date_text.dart';
import 'package:tn09_working_demo/math_function/get_duration.dart';
import 'package:tn09_working_demo/math_function/get_minute_duration.dart';
import 'package:tn09_working_demo/math_function/get_time_text.dart';
import 'package:tn09_working_demo/math_function/limit_length_string.dart';
import 'package:tn09_working_demo/widget/vehicule_icon.dart';
import 'package:location/location.dart';
import 'package:tn09_working_demo/.env.dart';
import 'package:tn09_working_demo/widget/company_position.dart' as company;
import 'package:tn09_working_demo/working_page/take_photo_widget.dart';
import 'package:tn09_working_demo/working_page/take_signature_widget.dart';
import 'package:tn09_working_demo/working_page/working_etape_page.dart';
import 'package:collection/collection.dart';
import 'package:tn09_working_demo/decoration/graphique.dart' as graphique;

class WorkingDoingEtapePage extends StatefulWidget {
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
  WorkingDoingEtapePage({
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
  _WorkingDoingEtapePageState createState() => _WorkingDoingEtapePageState();
}

class _WorkingDoingEtapePageState extends State<WorkingDoingEtapePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //For Collecteur
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference _collecteur =
      FirebaseFirestore.instance.collection("Collecteur");

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
  //for vehicule information
  late Widget vehicule_information;
  // For Etape
  CollectionReference _etape = FirebaseFirestore.instance.collection("Etape");
  // For Adresse
  CollectionReference _adresse =
      FirebaseFirestore.instance.collection("Adresse");
  // For Time and Duration
  String _timeString = '00:00';
  DateTime date = DateTime.now();
  // For DropDownMenu Data
  CollectionReference _typeContenant =
      FirebaseFirestore.instance.collection("TypeContenant");
  List<String> typeContenantCollect = [];
  List<int> numberOfContenant = [];
  var listnumber = [for (var i = 0; i <= 100; i++) i];
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 60), (Timer t) => _getDuration());
    _vehicule
        .where('idVehicule', isEqualTo: widget.dataTournee['idVehicule'])
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc_vehicule) {
        Map<String, dynamic> vehicule =
            doc_vehicule.data()! as Map<String, dynamic>;
        setState(() {
          vehicule_information = Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 30,
              color: Color(int.parse(widget.dataTournee['colorTournee'])),
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  buildVehiculeIcon(
                      icontype: vehicule['typeVehicule'],
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
                      fontWeight: FontWeight.bold,
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ));
        });
      });
    }).catchError((error) => print("Failed to add user: $error"));
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

  //For Google Map
  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapController;
  GoogleMapController? _controller;
  GoogleMapController? _googleMapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = Set<Polyline>();
  late LatLng _initialcameraposition;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(44.855601489864014, -0.5484378447808893),
    zoom: 15,
  );

  Location location = Location();

  LocationData? _currentPosition;
  late String _dateTime;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _controller;
    location.onLocationChanged.listen((l) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(double.parse((l.latitude).toString()),
                  double.parse((l.longitude).toString())),
              zoom: 15),
        ),
      );
    });
  }

  //Cancel Etape Dialog
  stopDoingDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Stop doing this Etape?'),
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
                  if (widget.dataEtape['signature'] != null) {
                    await _etape
                        .where('idEtape',
                            isEqualTo: widget.dataEtape['idEtape'])
                        .limit(1)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      querySnapshot.docs.forEach((doc_etape) {
                        _etape.doc(doc_etape.id).update({
                          'status': 'cancel',
                          'realStartTime': widget.realStartTime,
                        }).then((value) async {
                          Fluttertoast.showToast(
                              msg: "Etape Stopped", gravity: ToastGravity.TOP);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WorkingEtapePage(
                                      camera: widget.camera,
                                      thisDay: widget.thisDay,
                                      dataTournee: widget.dataTournee,
                                      dataCollecteur: widget.dataCollecteur,
                                      etapeFinish: widget.etapeFinish,
                                      etapeOK: widget.etapeOK,
                                      etapenotOK: widget.etapenotOK,
                                    )),
                          ).then((value) => setState(() {}));
                        });
                      });
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please Take a Signature",
                        gravity: ToastGravity.TOP);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }

  //load url
  String _imageUrl = '';
  //loat Signature
  String _signatureUrl = '';
  //For loading data
  void loadData() async {
    if (widget.dataEtape['image'] != null) {
      final image_ref =
          FirebaseStorage.instance.ref().child(widget.dataEtape['image']);
      var image_url = await image_ref.getDownloadURL();
      setState(() {
        _imageUrl = image_url;
      });
    }
    if (widget.dataEtape['signature'] != null) {
      final signature_ref =
          FirebaseStorage.instance.ref().child(widget.dataEtape['signature']);
      var signature_url = await signature_ref.getDownloadURL();
      setState(() {
        _signatureUrl = signature_url;
      });
    }
  }

  //For Save Contenant information
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    // Debug information
    // print('type contenant: ${widget.typeContenant}');
    //Load Data
    loadData();
    //For set up date
    DateTime nextDay = widget.thisDay.add(new Duration(days: 1));
    DateTime previousDay = widget.thisDay.subtract(Duration(days: 1));
    // inputData();
    //For list of Contenant
    List<Widget> list_contenant =
        List.generate(_count, (int i) => addContenant(element: i));
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
                child: SingleChildScrollView(
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
                            IconButton(
                                onPressed: () {
                                  stopDoingDialog();
                                },
                                icon: Icon(
                                  FontAwesomeIcons.arrowAltCircleLeft,
                                  size: 15,
                                  color: Color(graphique.color['main_color_2']),
                                )),
                            Text(
                              getDateText(date: widget.thisDay) +
                                  ' tournee ' +
                                  limitString(
                                      text: widget.dataTournee['idTournee'],
                                      limit_long: 15),
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
                                  child: Row(
                                    children: [
                                      vehicule_information == null
                                          ? SizedBox.shrink()
                                          : vehicule_information
                                    ],
                                  )
                                  // StreamBuilder<QuerySnapshot>(
                                  //   stream: _vehicule
                                  //       .where('idVehicule',
                                  //           isEqualTo:
                                  //               widget.dataTournee['idVehicule'])
                                  //       .limit(1)
                                  //       .snapshots(),
                                  //   builder: (BuildContext context,
                                  //       AsyncSnapshot<QuerySnapshot> snapshot) {
                                  //     if (snapshot.hasError) {
                                  //       print('${snapshot.error.toString()}');
                                  //       return Text('Something went wrong');
                                  //     }

                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return CircularProgressIndicator();
                                  //     }
                                  //     // print('$snapshot');

                                  //     return SingleChildScrollView(
                                  //       child: Row(
                                  //         children: snapshot.data!.docs.map(
                                  //             (DocumentSnapshot
                                  //                 document_vehicule) {
                                  //           Map<String, dynamic> vehicule =
                                  //               document_vehicule.data()!
                                  //                   as Map<String, dynamic>;
                                  //           // print('$collecteur');

                                  //           return Container(
                                  //               width: MediaQuery.of(context)
                                  //                       .size
                                  //                       .width *
                                  //                   0.8,
                                  //               height: 30,
                                  //               color: Color(int.parse(
                                  //                   widget.dataTournee[
                                  //                       'colorTournee'])),
                                  //               alignment: Alignment.topLeft,
                                  //               child: Row(
                                  //                 children: [
                                  //                   buildVehiculeIcon(
                                  //                       icontype: vehicule[
                                  //                           'typeVehicule'],
                                  //                       iconcolor: '0xff000000',
                                  //                       sizeIcon: 15),
                                  //                   SizedBox(
                                  //                     width: 10,
                                  //                   ),
                                  //                   Text(
                                  //                     'Vehicule: ',
                                  //                     style: TextStyle(
                                  //                       color: Colors.black,
                                  //                       fontSize: 18,
                                  //                       fontWeight:
                                  //                           FontWeight.bold,
                                  //                     ),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     width: 10,
                                  //                   ),
                                  //                   Text(
                                  //                     '${vehicule['nomVehicule']}  ${vehicule['numeroImmatriculation']}',
                                  //                     style: TextStyle(
                                  //                       color: Colors.black,
                                  //                       fontSize: 18,
                                  //                       fontWeight:
                                  //                           FontWeight.bold,
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ));
                                  //         }).toList(),
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
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
                                  'Etape' + widget.dataEtape['orderEtape'],
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
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 200,
                          margin: EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
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
                                      widget.dataEtape['nomAdresseEtape'],
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
                                        widget.dataEtape['ligne1Adresse'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
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
                                      widget.dataEtape['startFrequenceEtape'] +
                                          ' - ' +
                                          widget.dataEtape['endFrequenceEtape'],
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
                          )),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 600,
                        color: Colors.yellow,
                        child: FutureBuilder<String>(
                          future: Future<String>.delayed(
                            const Duration(seconds: 2),
                            () async {
                              List<LatLng> polylineCoordinates = [];
                              PolylinePoints polylinePoints = PolylinePoints();
                              double latitudeetape = 0;
                              double longitudeetape = 0;
                              String titleMarker = '';
                              await _adresse
                                  .where('idAdresse',
                                      isEqualTo:
                                          widget.dataEtape['idAdresseEtape'])
                                  .limit(1)
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                querySnapshot.docs.forEach((doc_adresse) {
                                  longitudeetape = double.parse(
                                      doc_adresse['longitudeAdresse']);
                                  latitudeetape = double.parse(
                                      doc_adresse['latitudeAdresse']);
                                  titleMarker = doc_adresse['ligne1Adresse'];
                                });
                              });
                              Marker etapemarker = Marker(
                                  markerId: MarkerId(
                                      '${widget.dataEtape['Partenaire Ex1 Adresse 2']}'),
                                  position:
                                      LatLng(latitudeetape, longitudeetape),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueRed),
                                  infoWindow: InfoWindow(
                                      title: titleMarker,
                                      snippet:
                                          '${widget.dataEtape['nomAdresseEtape']}'));

                              //Add markers
                              _markers.add(company.companyMarker);
                              _markers.add(etapemarker);

                              //Draw Polyline
                              //Have to draw from current position, but in the app it's in America so impossible
                              // PolylineResult result = await polylinePoints
                              //     .getRouteBetweenCoordinates(
                              //         googleAPIKey,
                              //         PointLatLng(44.85552543453359,
                              //             -0.5484378447808893),
                              //         PointLatLng(
                              //             latitudeetape, longitudeetape));
                              // print('Result Status  ${result.status}');
                              // if (result.status == 'OK') {
                              //   result.points.forEach((PointLatLng point) {
                              //     polylineCoordinates.add(
                              //         LatLng(point.latitude, point.longitude));
                              //   });
                              // }
                              //Find current position
                              bool _serviceEnabled;
                              PermissionStatus _permissionGranted;

                              _serviceEnabled = await location.serviceEnabled();
                              if (!_serviceEnabled) {
                                _serviceEnabled =
                                    await location.requestService();
                                if (!_serviceEnabled) {
                                  return 'Done';
                                }
                              }

                              _permissionGranted =
                                  await location.hasPermission();
                              if (_permissionGranted ==
                                  PermissionStatus.denied) {
                                _permissionGranted =
                                    await location.requestPermission();
                                if (_permissionGranted !=
                                    PermissionStatus.granted) {
                                  return 'Done';
                                }
                              }

                              _currentPosition = await location.getLocation();
                              _initialcameraposition = LatLng(
                                  double.parse(
                                      (_currentPosition?.latitude).toString()),
                                  double.parse((_currentPosition?.longitude)
                                      .toString()));
                              location.onLocationChanged
                                  .listen((LocationData currentLocation) {
                                Marker _yourPosition = Marker(
                                    markerId: MarkerId('Your_position'),
                                    position: LatLng(
                                        double.parse(
                                            (_currentPosition?.latitude)
                                                .toString()),
                                        double.parse(
                                            (_currentPosition?.longitude)
                                                .toString())),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueCyan),
                                    infoWindow:
                                        InfoWindow(title: 'Your Position'));
                                setState(() {
                                  //set up camera and position
                                  _currentPosition = currentLocation;
                                  _initialcameraposition = LatLng(
                                      double.parse((_currentPosition?.latitude)
                                          .toString()),
                                      double.parse((_currentPosition?.longitude)
                                          .toString()));
                                  _markers.add(company.companyMarker);
                                  _markers.add(_yourPosition);
                                  DateTime now = DateTime.now();
                                  _dateTime = DateFormat('EEE d MMM kk:mm:ss ')
                                      .format(now);
                                  //add polylines
                                  _polylines.add(Polyline(
                                    polylineId: PolylineId('Polyline_Etape_1'),
                                    width: 5,
                                    color: Colors.blue,
                                    points: polylineCoordinates,
                                  ));
                                });
                              });
                              return 'Done';
                            },
                          ), // a previously-obtained Future<String> or null
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            List<Widget> children;
                            if (snapshot.hasData) {
                              children = <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  height: 50,
                                  color: Colors.blue,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 20),
                                          Icon(
                                            FontAwesomeIcons.map,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Map',
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
                                  height: 500,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  color: Colors.red,
                                  child: GoogleMap(
                                    polylines: _polylines,
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: true,
                                    initialCameraPosition:
                                        _initialCameraPosition
                                    // CameraPosition(
                                    //     target: _initialcameraposition,
                                    //     zoom: 15)
                                    ,
                                    markers: _markers,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _mapController.complete(controller);
                                      //setPolylines();
                                    },
                                    //_onMapCreated
                                    gestureRecognizers: Set()
                                      ..add(Factory<EagerGestureRecognizer>(
                                          () => EagerGestureRecognizer())),
                                  ),
                                )
                              ];
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}'),
                                )
                              ];
                            } else {
                              children = const <Widget>[
                                SizedBox(
                                  child: CircularProgressIndicator(),
                                  width: 60,
                                  height: 60,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text('Awaiting result...'),
                                )
                              ];
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 600,
                        color: Colors.yellow,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                        FontAwesomeIcons.boxOpen,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Contenant',
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
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _count++;
                                        });
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.plus,
                                        size: 15,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 400,
                              color: Colors.red,
                              child: SingleChildScrollView(
                                child: Column(children: list_contenant),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 600,
                          color: Colors.yellow,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
                                          FontAwesomeIcons.image,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Photo',
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
                                height: 500,
                                width: MediaQuery.of(context).size.width * 0.95,
                                color: Colors.red,
                                child: _imageUrl == ''
                                    ? Image.asset('assets/logo_1.jpg')
                                    : Image.network(_imageUrl,
                                        fit: BoxFit.cover),
                              )
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 50,
                          color: Colors.blue,
                          alignment: Alignment(0, 0),
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TakePhotoWidget(
                                        camera: widget.camera,
                                        thisDay: widget.thisDay,
                                        dataCollecteur: widget.dataCollecteur,
                                        dataTournee: widget.dataTournee,
                                        dataEtape: widget.dataEtape,
                                        etapeFinish: widget.etapeFinish,
                                        etapeOK: widget.etapeOK,
                                        etapenotOK: widget.etapenotOK,
                                        realStartTime: widget.realStartTime,
                                        typeContenant: widget.typeContenant)),
                              ).then((value) => setState(() {}));
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
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 600,
                          color: Colors.yellow,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
                                          FontAwesomeIcons.signature,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Signature',
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
                                height: 500,
                                width: MediaQuery.of(context).size.width * 0.95,
                                color: Colors.white,
                                child: _signatureUrl == ''
                                    ? Image.asset('assets/logo_1.jpg')
                                    : Image.network(
                                        _signatureUrl,
                                        // fit: BoxFit.cover
                                      ),
                              )
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 50,
                          color: Colors.blue,
                          alignment: Alignment(0, 0),
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TakeSignatureWidget(
                                        camera: widget.camera,
                                        thisDay: widget.thisDay,
                                        dataCollecteur: widget.dataCollecteur,
                                        dataTournee: widget.dataTournee,
                                        dataEtape: widget.dataEtape,
                                        etapeFinish: widget.etapeFinish,
                                        etapeOK: widget.etapeOK,
                                        etapenotOK: widget.etapenotOK,
                                        realStartTime: widget.realStartTime,
                                        typeContenant: widget.typeContenant)),
                              ).then((value) => setState(() {}));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.signature,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Take Signature',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 80,
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.only(
                                    right: 10, top: 20, bottom: 20),
                                child: GestureDetector(
                                  onTap: () async {
                                    Map<String, dynamic> resultCollecte = {};
                                    for (int i = 0; i < _count; i++) {
                                      resultCollecte.putIfAbsent(
                                          typeContenantCollect[i]
                                              .toLowerCase()
                                              .replaceAll(' ', ''),
                                          () =>
                                              numberOfContenant[i].toString());
                                    }
                                    resultCollecte.putIfAbsent('idEtape',
                                        () => widget.dataEtape['idEtape']);
                                    resultCollecte.putIfAbsent('idTournee',
                                        () => widget.dataTournee['idTournee']);
                                    resultCollecte.putIfAbsent(
                                        'idCollecteur',
                                        () => widget
                                            .dataCollecteur['idCollecteur']);
                                    resultCollecte.putIfAbsent(
                                        'numberOfTypeContenant',
                                        () => _count.toString());
                                    resultCollecte.putIfAbsent(
                                        'numberOfContenant',
                                        () => numberOfContenant.sum.toString());
                                    String newidResult = FirebaseFirestore
                                        .instance
                                        .collection("Result")
                                        .doc()
                                        .id
                                        .toString();
                                    FirebaseFirestore.instance
                                        .collection("Result")
                                        .doc(newidResult)
                                        .set(resultCollecte);
                                    if (widget.dataEtape['signature'] != null) {
                                      await _etape
                                          .where('idEtape',
                                              isEqualTo:
                                                  widget.dataEtape['idEtape'])
                                          .limit(1)
                                          .get()
                                          .then((QuerySnapshot querySnapshot) {
                                        querySnapshot.docs.forEach((doc_etape) {
                                          _etape.doc(doc_etape.id).update({
                                            'resultCollecte': resultCollecte,
                                            'status': 'finished',
                                            'realStartTime':
                                                widget.realStartTime,
                                            'realEndTime': getTimeText(
                                                time: TimeOfDay.now()),
                                            'dureeMinute': getMinuteDuration(
                                                time: widget.dataEtape[
                                                    'realStartTime']),
                                            'duree': getDuration(
                                                time: widget.dataEtape[
                                                    'realStartTime']),
                                          }).then((value) async {
                                            Fluttertoast.showToast(
                                                msg: "Etape Finished",
                                                gravity: ToastGravity.TOP);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WorkingEtapePage(
                                                        camera: widget.camera,
                                                        thisDay: widget.thisDay,
                                                        dataTournee:
                                                            widget.dataTournee,
                                                        dataCollecteur: widget
                                                            .dataCollecteur,
                                                        etapeFinish:
                                                            widget.etapeFinish +
                                                                1,
                                                        etapeOK:
                                                            widget.etapeOK + 1,
                                                        etapenotOK:
                                                            widget.etapenotOK,
                                                      )),
                                            ).then((value) => setState(() {}));
                                          });
                                        });
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Please Take a Signature",
                                          gravity: ToastGravity.TOP);
                                    }
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
                            Container(
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.only(
                                    right: 10, top: 20, bottom: 20),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (widget.dataEtape['signature'] != null) {
                                      await _etape
                                          .where('idEtape',
                                              isEqualTo:
                                                  widget.dataEtape['idEtape'])
                                          .limit(1)
                                          .get()
                                          .then((QuerySnapshot querySnapshot) {
                                        querySnapshot.docs.forEach((doc_etape) {
                                          _etape.doc(doc_etape.id).update({
                                            'status': 'notfinished',
                                            'realStartTime':
                                                widget.realStartTime,
                                            'realEndTime': getTimeText(
                                                time: TimeOfDay.now()),
                                            'dureeMinute': getMinuteDuration(
                                                time: widget.dataEtape[
                                                    'realStartTime']),
                                            'duree': getDuration(
                                                time: widget.dataEtape[
                                                    'realStartTime']),
                                          }).then((value) async {
                                            Fluttertoast.showToast(
                                                msg: "Etape Not Finished",
                                                gravity: ToastGravity.TOP);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WorkingEtapePage(
                                                        camera: widget.camera,
                                                        thisDay: widget.thisDay,
                                                        dataTournee:
                                                            widget.dataTournee,
                                                        dataCollecteur: widget
                                                            .dataCollecteur,
                                                        etapeFinish:
                                                            widget.etapeFinish +
                                                                1,
                                                        etapeOK: widget.etapeOK,
                                                        etapenotOK:
                                                            widget.etapenotOK +
                                                                1,
                                                      )),
                                            ).then((value) => setState(() {}));
                                          });
                                        });
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Please Take a Signature",
                                          gravity: ToastGravity.TOP);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.times,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Not Finish',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.only(
                                    right: 10, top: 20, bottom: 20),
                                child: GestureDetector(
                                  onTap: () async {
                                    stopDoingDialog();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.ban,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  addContenant({required int element}) {
    typeContenantCollect.add('None');
    numberOfContenant.add(0);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      color: Colors.white,
      child: Row(
        children: [
          DropdownButton<String>(
            value: typeContenantCollect[element],
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 8,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                typeContenantCollect[element] = newValue!;
              });
              if (newValue == 'None') {
                Fluttertoast.showToast(
                    msg: "It's None", gravity: ToastGravity.TOP);
              }
              if (typeContenantCollect.contains(newValue)) {
                Fluttertoast.showToast(
                    msg: "You've added it", gravity: ToastGravity.TOP);
              }
            },
            items: widget.typeContenant
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(
            width: 20,
          ),
          DropdownButton<int>(
            value: numberOfContenant[element],
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 8,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (int? newValue) {
              setState(() {
                numberOfContenant[element] = newValue!;
              });
            },
            items: listnumber.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                numberOfContenant.removeAt(element);
                typeContenantCollect.removeAt(element);
                setState(() {
                  _count--;
                });
              },
              icon: Icon(
                FontAwesomeIcons.minus,
                size: 15,
                color: Colors.black,
              ))
        ],
      ),
    );
  }
}
