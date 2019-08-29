import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:time_tracker_flutter_course/app/home/maps/poly_drawer.dart';
//import 'package:permission/permission.dart';

// Hue used by the Google Map Markers to match the theme
//const _pinkHue = 210.0;
//const _pinkHue = 20.0;
Set<Marker> markers;
final _streamJobs = Firestore.instance.collection('entries').orderBy('id').snapshots();

//final ImageConfiguration imageConfiguration = createLocalImageConfiguration(context);

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key key,
    @required this.documents,
    @required this.initialPosition,
    @required this.mapController,
    @required this.polylines,
    @required this.defaultMapType,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;
  final Map<PolylineId, Polyline> polylines;
  final MapType defaultMapType;

  @override
  Widget build(BuildContext context) {
    //markers.clear();
    //getCreateMarkers();
    loadMarkers();
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 12.0,
      ),
      mapType: defaultMapType,
      markers: markers,
      polylines: Set<Polyline>.of(polylines.values),
      onMapCreated: (mapController) {
        this.mapController.complete(mapController);
      },
    );
  }

  Widget loadMarkers() {
    return StreamBuilder<QuerySnapshot>(
        stream: _streamJobs,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: const Text('Loading...'));
          }
          print('Loading Markers');
          return Stack(
            children: [
              Text('Loading Markers'),
            /*StoreMap(
                documents: snapshot.data.documents,
                initialPosition: initialPosition,
              ),*/
            ],
          );
        });
  }

/*void getCreateMarkers() {
    markers = documents
        .map((document) => Marker(
      markerId: MarkerId(document['id'] as String),
      //markerId: MarkerId(document['placeId'] as String),
      //onDragEnd:  (LatLng position) {_onMarkerDragEnd(MarkerId(document['placeId'] as String), position);},
      icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
      //icon: BitmapDescriptor.fromAssetImage(configuration, assetName),
      position: LatLng(
        document['location'].latitude as double,
        document['location'].longitude as double,
      ),
      infoWindow: InfoWindow(
        title: document['name'] as String,
        snippet: document['address'] as String,
      ),
    ))
        .toSet();

  }*/

/*void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }*/

}
