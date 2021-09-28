import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:tn09_app_demo/.env.dart';
import 'package:tn09_app_demo/page/testing_page/testing_function/blocs/application_bloc.dart';

class TestingSearchPage extends StatefulWidget {
  @override
  _TestingPageSearchState createState() => _TestingPageSearchState();
}

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleAPIKey);

class _TestingPageSearchState extends State<TestingSearchPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(44.855601489864014, -0.5484378447808893),
    zoom: 15,
  );

  Set<Marker> _markers = {};
  GoogleMapController? _googleMapController;
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
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
      ),
      body: (applicationBloc.currentLocation == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
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
                          _googleMapController = controller;
                          //setPolylines();
                        },
                        markers: {
                          _ourCompany,
                        },
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
                                  //
                                },
                              );
                            }),
                      ),
                  ],
                ),
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
}
