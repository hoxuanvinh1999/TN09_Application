import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:tn09_app_demo/.env.dart';
import 'package:tn09_app_demo/widget/company_position.dart' as company;

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
              company.companyMarker,
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
}
