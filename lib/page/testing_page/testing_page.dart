import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tn09_app_demo/.env.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

Set<Marker> _markers = {};
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleAPIKey);

class _TestingPageState extends State<TestingPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(44.855601489864014, -0.5484378447808893),
    zoom: 15,
  );

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Marker _ourCompany = Marker(
      markerId: MarkerId('les_detritivores'),
      position: LatLng(44.85552543453359, -0.5484378447808893),
      infoWindow:
          InfoWindow(title: 'Les detritivores', snippet: 'Our Company'));
  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          TextButton(
            onPressed: () async {
              // show input autocomplete with selected mode
              // then get the Prediction selected
              Prediction? predict = await PlacesAutocomplete.show(
                  context: context, apiKey: googleAPIKey);
              displayPrediction(predict: predict);
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('Find'),
          ),
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('Origin'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('Destination'),
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            polylines: _polylines,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
              //setPolylines();
            },
            markers: {
              _ourCompany,
              if (_origin != null) _origin!,
              if (_destination != null) _destination!,
            },
            onLongPress: _addMarker,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      _polylines.clear();
      polylineCoordinates.clear();
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        _destination = null;
        //polylineCoordinates.add(_origin!.position);
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
        //polylineCoordinates.add(_destination!.position);
      });
      setPolylines();

      _polylines.add(Polyline(
        polylineId: PolylineId('testing'),
        visible: true,
        points: polylineCoordinates,
        color: Colors.blue,
      ));
    }
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(_origin!.position.latitude, _origin!.position.longitude),
        PointLatLng(
            _destination!.position.latitude, _destination!.position.longitude));
    print('Result Status  ${result.status}');
    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('testing'),
          width: 5,
          color: Colors.red,
          points: polylineCoordinates,
        ));
      });
    }
  }

  Future<Null> displayPrediction({required Prediction? predict}) async {
    if (predict != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId((predict.placeId).toString());

      var placeId = predict.placeId;
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;

      var address =
          await Geocoder.local.findAddressesFromQuery(predict.description);

      print(lat);
      print(lng);
    }
  }
}
