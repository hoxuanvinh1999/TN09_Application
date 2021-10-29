import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:tn09_app_demo/.env.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/testing_page/testing_function/blocs/application_bloc.dart';
import 'package:tn09_app_demo/page/testing_page/testing_function/models/place.dart';
import 'package:tn09_app_demo/widget/company_position.dart' as company;

class ChoideAddressLocation extends StatefulWidget {
  String contactKey;
  String reason;
  ChoideAddressLocation({required this.contactKey, required this.reason});
  @override
  _TestingPageSearchState createState() => _TestingPageSearchState();
}

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleAPIKey);

class _TestingPageSearchState extends State<ChoideAddressLocation> {
  DatabaseReference referenceContact =
      FirebaseDatabase.instance.reference().child('Contact');
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(44.855601489864014, -0.5484378447808893),
    zoom: 15,
  );

  Set<Marker> _markers = {};
  GoogleMapController? _googleMapController;

  @override
  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription? locationSubscription;
  StreamSubscription? boundsSubscription;
  String idLocation = '';
  String addressLocation = '';
  String latitudeLocation = '';
  String longitudeLocation = '';
  final _locationController = TextEditingController();
  void initState() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    //Listen for selected Location
    locationSubscription = applicationBloc.selectedLocation.stream
        .asBroadcastStream()
        .listen((place) {
      if (place != null) {
        _locationController.text = place.name;
        _goToPlace(place);
        // _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
        //   CameraPosition(
        //       target: LatLng(
        //           place.geometry.location.lat, place.geometry.location.lng),
        //       zoom: 14.0),
        // ));
        // _markers.remove('now');
        _markers.add(Marker(
          markerId: MarkerId('${place.placeId}'),
          infoWindow: InfoWindow(title: place.name),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position:
              LatLng(place.geometry.location.lat, place.geometry.location.lng),
        ));
        String location_name = place.name;
      } else
        _locationController.text = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    _locationController.dispose();
    locationSubscription!.cancel();
    boundsSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    _markers.add(company.companyMarker);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            CancleCreateLocation();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        centerTitle: false,
        title: const Text('Google Maps'),
      ),
      body: (applicationBloc.currentLocation == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Search Location',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => applicationBloc.searchPlaces(value),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 600,
                      child: GoogleMap(
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              applicationBloc.currentLocation.latitude,
                              applicationBloc.currentLocation.altitude),
                          zoom: 15,
                        ),
                        // _initialCameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);
                          //setPolylines();
                        },
                        markers: _markers,
                        gestureRecognizers: Set()
                          ..add(Factory<EagerGestureRecognizer>(
                              () => EagerGestureRecognizer())),
                      ),
                    ),
                    if (applicationBloc.searchResults != [] &&
                        applicationBloc.searchResults.length != 0)
                      Container(
                          height: 600.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.6),
                          )),
                    if (applicationBloc.searchResults != [])
                      Container(
                        height: 600.0,
                        child: ListView.builder(
                            itemCount: applicationBloc.searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  applicationBloc
                                      .searchResults[index].description,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  applicationBloc.setSelectedLocation(
                                      applicationBloc
                                          .searchResults[index].placeId);
                                },
                              );
                            }),
                      ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: RaisedButton(
                    child: Text(
                      'Créer Location',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      FinishSaveLocation();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition
              // CameraPosition(
              //   target: LatLng(applicationBloc.currentLocation.latitude,
              //       applicationBloc.currentLocation.altitude),
              //   zoom: 15,),
              ),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Future<void> _goToPlace(Place place) async {
    latitudeLocation = (place.geometry.location.lat).toString();
    longitudeLocation = (place.geometry.location.lng).toString();
    idLocation = place.placeId;
    addressLocation = place.formatted_address;
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                place.geometry.location.lat, place.geometry.location.lng),
            zoom: 14.0),
      ),
    );
  }

  void FinishSaveLocation() async {
    String locationKey = '';
    DataSnapshot snapshotlocation =
        await referenceContact.child(widget.contactKey).once();
    Map contact = snapshotlocation.value;
    String numberofLocation = contact['nombredelocation'];
    numberofLocation = (int.parse(numberofLocation) + 1).toString();
    Map<String, String> updateContact = {
      'nombredelocation': numberofLocation,
    };
    referenceContact.child(widget.contactKey).update(updateContact);
    await referenceLocation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> location = snapshot.value;
      location.forEach((key, values) {
        if (values['checked'] == 'creating') {
          Map<String, String> update_location = {
            'contact_key': widget.contactKey,
            'addressLocation': addressLocation,
            'idLocation': idLocation,
            'longitudeLocation': longitudeLocation,
            'latitudeLocation': latitudeLocation,
            'nombredecle': '0',
            'showed': 'false',
            'checked': 'done',
          };
          locationKey = key;
          referenceLocation.child(key).update(update_location);
        }
      });
    });

    await referenceTotalInformation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> information = snapshot.value;
      information.forEach((key, values) {
        Map<String, String> totalInformation = {
          'nombredeLocation':
              (int.parse(values['nombredeLocation']) + 1).toString(),
        };
        referenceTotalInformation.child(key).update(totalInformation);
      });
    });
  }

  void CancleCreateLocation() async {
    await referenceLocation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> location = snapshot.value;
      location.forEach((key, values) {
        if (values['checked'] == 'creating') {
          referenceLocation.child(key).remove();
        }
      });
    });
  }
}
