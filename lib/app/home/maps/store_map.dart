import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:permission/permission.dart';
//import 'package:time_tracker_flutter_course/app/home/maps/poly_drawer.dart';

// Hue used by the Google Map Markers to match the theme
//const _pinkHue = 350.0;
const _pinkHue = 210.0;

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key key,
    @required this.documents,
    @required this.initialPosition,
    @required this.mapController,
    @required this.polylines,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;
  final Map<PolylineId, Polyline> polylines;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 12,
      ),
      markers: documents
          .map((document) => Marker(
                markerId: MarkerId(document['placeId'] as String),
                icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
                position: LatLng(
                  document['location'].latitude as double,
                  document['location'].longitude as double,
                ),
                infoWindow: InfoWindow(
                  title: document['name'] as String,
                  snippet: document['address'] as String,
                ),
              ))
          .toSet(),
      polylines: Set<Polyline>.of(polylines.values),
      onMapCreated: (mapController) {
        this.mapController.complete(mapController);
      },
    );
  }

}
