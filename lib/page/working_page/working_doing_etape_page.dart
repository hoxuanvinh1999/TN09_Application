import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:tn09_app_demo/math_function/get_date_text.dart';
import 'package:tn09_app_demo/math_function/get_duration.dart';
import 'package:tn09_app_demo/math_function/get_minute_duration.dart';
import 'package:tn09_app_demo/math_function/get_time_text.dart';
import 'package:tn09_app_demo/math_function/limit_length_string.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/working_page/working_etape_page.dart';
import 'package:tn09_app_demo/page/working_page/working_page.dart';
import 'package:tn09_app_demo/widget/vehicule_icon.dart';
import 'package:location/location.dart';
import 'package:tn09_app_demo/.env.dart';
import 'package:tn09_app_demo/widget/company_position.dart' as company;

class WorkingDoingEtapePage extends StatefulWidget {
  DateTime thisDay;
  Map dataCollecteur;
  Map dataTournee;
  Map dataEtape;
  int etapeFinish;
  int etapeOK;
  int etapenotOK;
  String realStartTime;
  WorkingDoingEtapePage({
    required this.thisDay,
    required this.dataCollecteur,
    required this.dataTournee,
    required this.dataEtape,
    required this.etapeFinish,
    required this.etapeOK,
    required this.etapenotOK,
    required this.realStartTime,
  });
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
  // For Etape
  CollectionReference _etape = FirebaseFirestore.instance.collection("Etape");
  // For Adresse
  CollectionReference _adresse =
      FirebaseFirestore.instance.collection("Adresse");
  // For Time and Duration
  String _timeString = '00:00';

  DateTime date = DateTime.now();
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
                  await _etape
                      .where('idEtape', isEqualTo: widget.dataEtape['idEtape'])
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
                              PolylineResult result = await polylinePoints
                                  .getRouteBetweenCoordinates(
                                      googleAPIKey,
                                      PointLatLng(44.85552543453359,
                                          -0.5484378447808893),
                                      PointLatLng(
                                          latitudeetape, longitudeetape));
                              print('Result Status  ${result.status}');
                              if (result.status == 'OK') {
                                result.points.forEach((PointLatLng point) {
                                  polylineCoordinates.add(
                                      LatLng(point.latitude, point.longitude));
                                });
                              }
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
                                    await _etape
                                        .where('idEtape',
                                            isEqualTo:
                                                widget.dataEtape['idEtape'])
                                        .limit(1)
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      querySnapshot.docs.forEach((doc_etape) {
                                        _etape.doc(doc_etape.id).update({
                                          'status': 'finished',
                                          'realStartTime': widget.realStartTime,
                                          'realEndTime': getTimeText(
                                              time: TimeOfDay.now()),
                                          'dureeMinute': getMinuteDuration(
                                              time: widget
                                                  .dataEtape['realStartTime']),
                                          'duree': getDuration(
                                              time: widget
                                                  .dataEtape['realStartTime']),
                                        }).then((value) async {
                                          Fluttertoast.showToast(
                                              msg: "Etape Finished",
                                              gravity: ToastGravity.TOP);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkingEtapePage(
                                                      thisDay: widget.thisDay,
                                                      dataTournee:
                                                          widget.dataTournee,
                                                      dataCollecteur:
                                                          widget.dataCollecteur,
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
                                          'realStartTime': widget.realStartTime,
                                          'realEndTime': getTimeText(
                                              time: TimeOfDay.now()),
                                          'dureeMinute': getMinuteDuration(
                                              time: widget
                                                  .dataEtape['realStartTime']),
                                          'duree': getDuration(
                                              time: widget
                                                  .dataEtape['realStartTime']),
                                        }).then((value) async {
                                          Fluttertoast.showToast(
                                              msg: "Etape Not Finished",
                                              gravity: ToastGravity.TOP);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkingEtapePage(
                                                      thisDay: widget.thisDay,
                                                      dataTournee:
                                                          widget.dataTournee,
                                                      dataCollecteur:
                                                          widget.dataCollecteur,
                                                      etapeFinish:
                                                          widget.etapeFinish +
                                                              1,
                                                      etapeOK: widget.etapeOK,
                                                      etapenotOK:
                                                          widget.etapenotOK + 1,
                                                    )),
                                          ).then((value) => setState(() {}));
                                        });
                                      });
                                    });
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
}
