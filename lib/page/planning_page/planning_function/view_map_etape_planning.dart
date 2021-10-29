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
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/widget/company_position.dart' as company;

class ViewMapEtapePlanning extends StatefulWidget {
  Map planning;
  List<double> listlongitudeLocation;
  List<double> listlatitudeLocation;
  List<String> listidLocation;
  List<String> listNomLocationEtape;
  ViewMapEtapePlanning(
      {required this.planning,
      required this.listNomLocationEtape,
      required this.listidLocation,
      required this.listlatitudeLocation,
      required this.listlongitudeLocation});
  @override
  _ViewMapEtapePlanningState createState() => _ViewMapEtapePlanningState();
}

Set<Marker> _markers = {};
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleAPIKey);

class _ViewMapEtapePlanningState extends State<ViewMapEtapePlanning> {
  Future<List<String>> futureWait() async {
    return Future.wait([
      Future.delayed(const Duration(seconds: 1), () => drawMarkerEtape()),
      Future.delayed(const Duration(seconds: 1), () => drawPolylineEtape()),
    ]);
  }

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

  late double startLongtitude;
  late double startLatitude;
  late double endLatitude;
  late double endLongtitude;
  int check_draw_polyline = 0;
  drawPolylineEtape() async {
    widget.listNomLocationEtape..toSet().toList();
    widget.listidLocation.toSet().toList();
    widget.listlatitudeLocation.toSet().toList();
    widget.listlongitudeLocation.toSet().toList();
    if (check_draw_polyline >= int.parse(widget.planning['nombredeEtape'])) {
      return;
    } else {
      for (int i = 0; i < (int.parse(widget.planning['nombredeEtape'])); i++) {
        if (i == 0 && check_draw_polyline == 0) {
          print('check draw polyline $check_draw_polyline');
          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
                  googleAPIKey,
                  PointLatLng(44.85552543453359, -0.5484378447808893),
                  PointLatLng(widget.listlatitudeLocation[0],
                      widget.listlongitudeLocation[0]));
          // print('Result Status  ${result.status}');
          if (result.status == 'OK') {
            result.points.forEach((PointLatLng point) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
            setState(() {
              _polylines.add(Polyline(
                polylineId: PolylineId('polyline_0'),
                width: 5,
                color: Colors.red,
                points: polylineCoordinates,
              ));
            });
            check_draw_polyline++;
          }
        } else {
          print('check draw polyline $check_draw_polyline');
          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
                  googleAPIKey,
                  PointLatLng(widget.listlatitudeLocation[i - 1],
                      widget.listlongitudeLocation[i - 1]),
                  PointLatLng(widget.listlatitudeLocation[i],
                      widget.listlongitudeLocation[i]));
          // print('Result Status  ${result.status}');
          if (result.status == 'OK') {
            result.points.forEach((PointLatLng point) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
            setState(() {
              _polylines.add(Polyline(
                polylineId: PolylineId('polyline_$i'),
                width: 5,
                color: Colors.red,
                points: polylineCoordinates,
              ));
            });
            check_draw_polyline++;
          }
        }
      }
    }
    _polylines.toSet().toList();
  }

  int check_draw_marker = 0;
  drawMarkerEtape() async {
    _markers.add(company.companyMarker);
    widget.listNomLocationEtape..toSet().toList();
    widget.listidLocation.toSet().toList();
    widget.listlatitudeLocation.toSet().toList();
    widget.listlongitudeLocation.toSet().toList();
    print('drawMarkerEtape: ${widget.listNomLocationEtape}');
    print('widget planning nombredeEtape ${widget.planning['nombredeEtape']}');
    if (check_draw_marker >= int.parse(widget.planning['nombredeEtape'])) {
      return;
    } else {
      for (int i = 0; i < int.parse(widget.planning['nombredeEtape']); i++) {
        print('check draw marker $check_draw_marker');
        check_draw_marker++;
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(widget.listidLocation[i]),
            infoWindow: InfoWindow(title: widget.listNomLocationEtape[i]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: LatLng(widget.listlatitudeLocation[i],
                widget.listlongitudeLocation[i]),
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    drawMarkerEtape();
    drawPolylineEtape();
    return FutureBuilder<List<String>>(
        future: futureWait(),
        builder: (context, snapshot) {
          //print('$snapshot');
          if (check_draw_marker >=
                  int.parse(widget.planning['nombredeEtape']) &&
              check_draw_polyline >=
                  int.parse(widget.planning['nombredeEtape'])) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                centerTitle: false,
                title: const Text('Google Maps'),
              ),
              body: Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    polylines: _polylines,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _googleMapController = controller;
                    },
                    markers: _markers,
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
          return const Center(child: CircularProgressIndicator());
        });
  }
}
