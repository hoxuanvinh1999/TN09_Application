import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/testing_page/directions_model.dart';
import 'package:tn09_app_demo/page/testing_page/directions_repository.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

Set<Marker> _markers = {};

class _TestingPageState extends State<TestingPage> {
  static const _initialCameraPosition = CameraPosition(
      target: LatLng(44.85552543453359, -0.5484378447808893), zoom: 15);
  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  void _onMapCreated() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('les_detritivores'),
          position: LatLng(44.85552543453359, -0.5484378447808893),
          infoWindow:
              InfoWindow(title: 'Les detritivores', snippet: 'Our Company')));
      _markers.add(_origin!);
      _markers.add(_destination!);
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Testing'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
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
                    primary: Colors.green,
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
                    primary: Colors.blue,
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
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) => _googleMapController = controller,
                markers: _markers,
                polylines: {
                  if (_info != null)
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: Colors.red,
                      width: 5,
                      points: _info!.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                },
                onLongPress: _addMarker,
              ),
              if (_info != null)
                Positioned(
                  top: 20.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        )
                      ],
                    ),
                    child: Text(
                      '${_info!.totalDistance}, ${_info!.totalDuration}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.black,
            onPressed: () {
              _googleMapController!.animateCamera(
                  CameraUpdate.newCameraPosition(_initialCameraPosition));
            },
            child: Icon(Icons.center_focus_strong),
          ),
        ),
      );
  void _addMarker(LatLng positionsite) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: positionsite,
        );
        _markers.add(_origin!);
        _markers.remove(_destination);
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: positionsite,
        );
        _markers.add(_destination!);
        _info = null;
      });
      final directions = await DirectionsRepository()
          .getDirections(origin: _origin!.position, destination: positionsite);
      setState(() => _info = directions);
    }
  }
}
